import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_staff_list.dart';
import '../../domain/usecases/get_suspend_list.dart';

import 'staff_event.dart';
import 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final GetStaffList getStaffList;
  final GetSuspendStaffList getSuspendList;

  StaffBloc({required this.getStaffList, required this.getSuspendList})
      : super(StaffInitial()) {
    on<GetStaffEvent>(_onGetStaff);
    on<GetSuspendEvent>(_onGetSuspend);
  }

  Future<void> _onGetStaff(
      GetStaffEvent event, Emitter<StaffState> emit) async {
    emit(StaffLoading());
    try {
      final staffList = await getStaffList();
      emit(StaffLoaded(staffList));
    } catch (e) {
      emit(StaffError(e.toString()));
    }
  }

  Future<void> _onGetSuspend(
      GetSuspendEvent event, Emitter<StaffState> emit) async {
    emit(StaffLoading());
    try {
      final staffList = await getSuspendList();
      emit(StaffLoaded(staffList));
    } catch (e) {
      emit(StaffError(e.toString()));
    }
  }
}

