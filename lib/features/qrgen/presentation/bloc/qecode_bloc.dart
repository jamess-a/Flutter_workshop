import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qrcode_event.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qrcode_state.dart';
import 'package:shopee/features/qrgen/model/qrcode_model.dart';

import 'package:http/http.dart' as http;
import 'package:shopee/features/qrgen/model/qrcode_res_model.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  QrCodeBloc() : super(QrCodeInitial()) {
    on<PostQrCode>((event, emit) async {
      emit(QrCodeLoading());
      final qr = QrCode(
        bankid: event.bankid,
        useruid: event.useruid,
        divided: event.divided,
        amount: event.amount,
        timestamp: event.timestamp,
        status: event.status,
      );
      print("📦 Sending QR: ${jsonEncode(qr.toJson())}");

      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/transaction/QRPayment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(qr.toJson()),
      );

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];
        final qrResponse = QrCodeResponse.fromJson(data);

        emit(QrCodeLoaded(qrResponse));
      } else {
        emit(QrCodeError(response.body.toString()));
      }
    });
  }
}
