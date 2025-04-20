import '../model/staff_model.dart';

abstract class StaffState {}

class StaffInitial extends StaffState {}

class StaffLoaded extends StaffState {
  final List<Staff> staffList;

  StaffLoaded(this.staffList);
}

class StaffError extends StaffState {
  final String string;
  StaffError(this.string);
}

class StaffLoading extends StaffState {}
