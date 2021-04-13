import 'package:flutter/material.dart';
import 'package:khalti_sdk_flutter/model/khalti.dart';
import 'package:khalti_sdk_flutter/pages/payment_page.dart';

///  Khalti SDK.
class Khalti {
  /// Configuration Options for Khalti SDK
  final KhaltiConfig config;

  Khalti({required this.config});

  /// Returns [response] from payment api.
  Future<KhaltiResponse> makePayment(BuildContext context) async {
    final KhaltiResponse response = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => KhaltiPaymentPage(
          config: config,
        ),
      ),
    );

    return response;
  }
}
