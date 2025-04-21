import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shopee/features/qrgen/model/qrcode_res_model.dart';
import 'package:shopee/core/utils/promptpaygen.dart';

class QrCodeGen extends StatelessWidget {
  final QrCodeResponse qrData;

  const QrCodeGen({
    super.key,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final qrString = generatePromptPayPayload(
      id: qrData.bankId, 
      amount: qrData.amount.toDouble(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB3C6),
        title: const Text('QR Code ของคุณ'),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '✨ สแกนเลยน้า ✨',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDD4A74),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: const Divider(
                  height: 10,
                  thickness: 2,
                  color: Color(0xFFDD4A74),
                ),
              ),
              Text(
                ' จำนวนเงิน ${qrData.amount} บาท',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDD4A74),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: QrImageView(
                    data: qrString,
                    version: QrVersions.auto,
                    size: 220.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.circle,
                      color: Color(0xFFDD4A74),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('กลับไปหน้าก่อน'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB3C6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
