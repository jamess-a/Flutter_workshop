import '../entities/staff.dart';
import '../repositories/staff_repository.dart';

class GetStaffList {
  final StaffRepository repository;

  GetStaffList(this.repository);

  Future<List<Staff>> call() {
    return repository.getAllStaff();
  }
}
