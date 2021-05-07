part of 'khaltipayment_cubit.dart';

@immutable
abstract class KhaltiPaymentState {}

class KhaltiPaymentInitial extends KhaltiPaymentState {}

class PaymenLoading extends KhaltiPaymentState {}

class OtpSent extends KhaltiPaymentState {}

class OtpVerified extends KhaltiPaymentState {
  final KhaltiResponse response;
  OtpVerified({
    @required this.response,
  });
}

class OtpVerificationFailed extends KhaltiPaymentState {
  final String msg;

  OtpVerificationFailed({
    @required this.msg,
  });
}

class OtpSendError extends KhaltiPaymentState {
  final String msg;
  OtpSendError({
    @required this.msg,
  });
}

class ErrorLoadingBanks extends KhaltiPaymentState {}

class BanksLoading extends KhaltiPaymentState {}

class BanksLoaded extends KhaltiPaymentState {
  final List<KhaltiBanks> banks;

  BanksLoaded(this.banks);
}
