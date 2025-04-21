import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qecode_bloc.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qrcode_event.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qrcode_state.dart';
import 'package:shopee/features/qrgen/presentation/pages/qrcode_generator.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bankidController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _dividedController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _bankidController.dispose();
    _useridController.dispose();
    _dividedController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final date = DateTime.now().toIso8601String();

      BlocProvider.of<QrCodeBloc>(context).add(
        PostQrCode(
          bankid: _bankidController.text,
          useruid: _useridController.text,
          divided: int.tryParse(_dividedController.text),
          amount: int.tryParse(_amountController.text),
          timestamp: date,
          status: 'pending',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEF4),
      appBar: AppBar(
        title: const Text('สร้าง QR Code'),
        backgroundColor: const Color(0xFFFB8DA0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<QrCodeBloc, QrCodeState>(
        listener: (context, state) {
          if (state is QrCodeLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => QrCodeGen(qrData: state.response)),
            );
          } else if (state is QrCodeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is QrCodeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(_bankidController, 'Promt Pay',
                          icon: Icons.account_balance),
                      _buildTextField(_useridController, 'User ID',
                          icon: Icons.person),
                      _buildTextField(_dividedController, 'Divided',
                          isNumber: true, icon: Icons.grid_view),
                      _buildTextField(_amountController, 'Amount',
                          isNumber: true, icon: Icons.attach_money),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB8DA0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                        ),
                        onPressed: _submitForm,
                        icon: const Icon(
                          Icons.qr_code,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'สร้าง QR Code',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.pinkAccent) : null,
          filled: true,
          fillColor: const Color(0xFFFDF2F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'กรุณากรอก $label' : null,
      ),
    );
  }
}
