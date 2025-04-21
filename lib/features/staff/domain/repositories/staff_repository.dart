import '../entities/staff.dart';

abstract class StaffRepository {
  Future<List<Staff>> getAllStaff();
  Future<List<Staff>> getAllSuspendStaffs();
}
