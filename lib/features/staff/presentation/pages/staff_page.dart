import 'package:flutter/material.dart';
import 'package:shopee/core/widgets/top_overlay_snackbar.dart';
import 'package:shopee/features/staff/model/staff_model.dart';
import 'package:shopee/features/staff/presentation/pages/staffdetail_tap.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/staff/bloc/staff_bloc.dart';
import 'package:shopee/features/staff/bloc/staff_event.dart';
import 'package:shopee/features/staff/bloc/staff_state.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  void _openModalBottomSheet(BuildContext context, Staff staff) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => StaffDetail(staff: staff),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✨ Random Quote App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              final bloc = context.read<StaffBloc>();
              bloc.add(GetStaffEvent());
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<StaffBloc, StaffState>(
                    builder: (context, state) {
                      if (state is StaffInitial) {
                        return Center(
                          child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color.fromARGB(255, 184, 174, 174),
                              ),
                              child: const Center(
                                  child: Text(
                                "Welcome to Staff page",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ))),
                        );
                      } else if (state is StaffLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is StaffLoaded) {
                        return Center(
                          child: ListView.builder(
                            itemCount: state.staffList.length,
                            itemBuilder: (context, index) {
                              final staff = state.staffList[index];
                              return InkWell(
                                  onTap: () {
                                    _openModalBottomSheet(context, staff);
                                  },
                                  child: ListTile(
                                    title: Text(staff.username ?? ''),
                                    subtitle: Text(staff.email ?? ''),
                                    leading: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar-anika-visser.png'),
                                    ),
                                  ));
                            },
                          ),
                        );
                      } else {
                        return Container(
                          child: Text(state.toString()),
                        );
                      }
                    },
                  ))),
        ],
      ),
    );
  }
}
