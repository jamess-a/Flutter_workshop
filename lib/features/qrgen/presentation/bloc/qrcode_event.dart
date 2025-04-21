abstract class QrCodeEvent {}

class PostQrCode extends QrCodeEvent {
  final String? bankid;
  final String? useruid;
  final int? divided;
  final int? amount;
  final String? timestamp;
  final String? status;

  PostQrCode(
      {required this.bankid,
      this.useruid,
      this.divided,
      this.amount,
      this.timestamp,
      this.status});
}
