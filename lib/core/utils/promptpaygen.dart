String generatePromptPayPayload({
  required String id,
  double? amount,
  String? bankId,
}) {
  const payloadFormat = '000201';
  const method = '010212';

  // Merchant Account Info (เพิ่ม bankId เพื่อระบุบัญชีธนาคาร)
  final guid = 'A000000677010111';
  final idTag = id.length < 13 ? '01' : '02';
  final idLength = id.length.toString().padLeft(2, '0');
  final merchantAccountInfo = '0016$guid$idTag$idLength$id';

  // หากมี bankId จะใช้ข้อมูลนี้ใน merchantAccount
  String merchantAccount = '';
  if (bankId != null && bankId.isNotEmpty) {
    final bankIdLength = bankId.length.toString().padLeft(2, '0');
    merchantAccount =
        '29${(merchantAccountInfo.length + bankId.length + 2).toString().padLeft(2, '0')}$merchantAccountInfo$bankIdLength$bankId';
  } else {
    final merchantAccountLength =
        merchantAccountInfo.length.toString().padLeft(2, '0');
    merchantAccount = '29$merchantAccountLength$merchantAccountInfo';
  }

  // Currency
  const currency = '5303764';

  // Amount
  String amountField = '';
  if (amount != null && amount > 0) {
    final amtStr = amount.toStringAsFixed(2);
    amountField = '54${amtStr.length.toString().padLeft(2, '0')}$amtStr';
  }

  // Country
  const country = '5802TH';

  // Checksum placeholder
  const checksumPlaceholder = '6304';

  final rawData =
      '$payloadFormat$method$merchantAccount$currency$amountField$country$checksumPlaceholder';
  final checksum = _generateCRC(rawData);
  return rawData + checksum;
}

String _generateCRC(String input) {
  int crc = 0xFFFF;
  for (int i = 0; i < input.length; i++) {
    crc ^= input.codeUnitAt(i) << 8;
    for (int j = 0; j < 8; j++) {
      if ((crc & 0x8000) != 0) {
        crc = (crc << 1) ^ 0x1021;
      } else {
        crc <<= 1;
      }
    }
  }
  crc &= 0xFFFF;
  return crc.toRadixString(16).padLeft(4, '0').toUpperCase();
}
