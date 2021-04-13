import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:khalti_sdk_flutter/model/khalti.dart';

part 'khaltipayment_state.dart';

class KhaltiPaymentCubit extends Cubit<KhaltiPaymentState> {
  KhaltiPaymentCubit(
    this.config,
  ) : super(KhaltiPaymentInitial());
  final KhaltiConfig config;

  String? pin;
  String? otp;
  String? token;
  int tabIndex = 0;
  bool isBusy = false;

  List<KhaltiBanks> banks = [];
  processWalletPayment() async {
    isBusy = true;
    emit(PaymenLoading());

    Map<String, dynamic> _data = {
      "public_key": config.publicKey,
      "mobile": config.mobile,
      "transaction_pin": pin,
      "amount": config.amount.toString(),
      "product_identity": config.productIdentity,
      "product_name": config.productName,
      "product_url": config.productUrl
    };

    var client = http.Client();
    http.Response response;
    try {
      response = await client.post(
          Uri.parse('https://khalti.com/api/v2/payment/initiate/'),
          body: _data);
    } finally {
      client.close();
    }
    final resp = jsonDecode(response.body);
    if (response.statusCode != 200) {
      emit(OtpSendError(msg: resp['detail']));
    } else {
      token = resp['token'];
      emit(OtpSent());
    }
  }

  confirmOtp() async {
    isBusy = true;
    emit(PaymenLoading());
    Map<String, dynamic> _data = {
      "public_key": config.publicKey,
      "token": token,
      "transaction_pin": pin,
      "confirmation_code": otp
    };
    var client = http.Client();
    http.Response response;

    try {
      response = await client.post(
          Uri.parse('https://khalti.com/api/v2/payment/confirm/'),
          body: _data);
    } finally {
      client.close();
    }

    final resp = jsonDecode(response.body);
    // print(resp);
    if (response.statusCode != 200) {
      emit(OtpVerificationFailed(msg: resp['detail']));
    } else {
      isBusy = false;
      emit(
        OtpVerified(
          response: KhaltiResponse(
              message:
                  'Please do server side verification to complete the transaction ',
              sucess: true,
              token: resp['token']),
        ),
      );
    }
  }

  loadBanks() async {
    emit(BanksLoading());
    emit(ErrorLoadingBanks());
    // var client = http.Client();
    // http.Response response;
    // try {
    //   response = await client.get(
    //     Uri.parse('https://khalti.com/api/bank/?has_ebanking=true'),
    //   );
    // } finally {
    //   client.close();
    // }
    // if (response.statusCode != 200) {
    //   emit(ErrorLoadingBanks());
    // } else {
    //   final resp = jsonDecode(response.body)['records'] as List;

    //   final _banks = resp.map((data) => KhaltiBanks.fromMap(data)).toList();

    //   emit(BanksLoaded(_banks));
    // }
  }
}
