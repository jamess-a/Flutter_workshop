class QrCodeResponse {
  final String transactionRef;
  final String bankId;
  final int divided;
  final int amount;
  final String timestamp;
  final String userUid;
  final String status;

  QrCodeResponse({
    required this.transactionRef,
    required this.bankId,
    required this.divided,
    required this.amount,
    required this.timestamp,
    required this.userUid,
    required this.status,
  });

  factory QrCodeResponse.fromJson(Map<String, dynamic> json) {
    return QrCodeResponse(
      transactionRef: json['transaction_ref'],
      bankId: json['bank_id'],
      divided: json['divided'],
      amount: json['amount'],
      timestamp: json['timestamp'],
      userUid: json['user_uid'],
      status: json['status'],
    );
  }
}
