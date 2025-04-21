class QrCode {
  final String? bankid;
  final String? useruid;
  final int? divided;
  final int? amount;
  final String? timestamp;
  final String? status;

  QrCode(
      {required this.bankid,
      this.useruid,
      this.divided,
      this.amount,
      this.timestamp,
      this.status});

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankid,
      'user_uid': useruid,
      'divided': divided,
      'amount': amount,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
