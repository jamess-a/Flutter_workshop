import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../model/staff_model.dart';

import 'staff_event.dart';
import 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final List<Staff> staffList = [];

  StaffBloc() : super(StaffInitial()) {
    on<GetStaffEvent>((event, emit) async {
      emit(StaffLoading());
      try {
        final response =
            await http.get(Uri.parse('http://10.0.2.2:5000/employees'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonMap = jsonDecode(response.body);
          print(
              '🛰 Raw Response Body: ${response.body}'); // ดูข้อมูลดิบที่ได้จาก API

          // ดึงข้อมูลจาก key 'data' แล้วแปลงเป็น List ของ Staff
          final data = jsonMap['data'] as List;
          final staffListFromApi = data.map((e) => Staff.fromJson(e)).toList();

          staffList.clear();
          staffList.addAll(staffListFromApi);

          // Emit the loaded staff data
          emit(StaffLoaded(List<Staff>.from(staffList)));
        } else {
          emit(StaffError('Error: ${response.statusCode}'));
        }
      } catch (e) {
        print("x error: $e");
        emit(StaffError(e.toString()));
      }
    });
  }
}
