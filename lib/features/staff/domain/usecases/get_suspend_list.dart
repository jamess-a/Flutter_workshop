import '../entities/staff.dart';
import '../repositories/staff_repository.dart';

class GetSuspendStaffList {
  final StaffRepository repository;

  GetSuspendStaffList(this.repository);

  Future<List<Staff>> call() {
    return repository.getAllSuspendStaffs();
  }
}
