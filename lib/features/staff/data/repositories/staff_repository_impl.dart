import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/staff.dart';
import '../../domain/repositories/staff_repository.dart';
import '../models/staff_model.dart';

class StaffRepositoryImpl implements StaffRepository {
  // ดึงข้อมูล staff ทั้งหมด
  @override
  Future<List<Staff>> getAllStaff() async {
    await Future.delayed(const Duration(seconds: 3));
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/employees'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final data = jsonMap['data'] as List;
      return data.map((e) => StaffModel.fromJson(e)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  // ดึงข้อมูล staff ที่ถูก suspend
  @override
  Future<List<Staff>> getAllSuspendStaffs() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/employees/suspended'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final data = jsonMap['data'] as List;
      return data.map((e) => StaffModel.fromJson(e)).toList();
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
