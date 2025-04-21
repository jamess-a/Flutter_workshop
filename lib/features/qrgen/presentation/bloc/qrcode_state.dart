import 'package:shopee/features/qrgen/model/qrcode_res_model.dart';

abstract class QrCodeState {}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoaded extends QrCodeState {
  final QrCodeResponse response;

  QrCodeLoaded(this.response);
}

class QrCodeError extends QrCodeState {
  final String message;

  QrCodeError(this.message);
}

class QrCodeLoading extends QrCodeState {}
