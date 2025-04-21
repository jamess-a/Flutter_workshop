import 'package:flutter/material.dart';
import 'package:shopee/core/widgets/top_overlay_snackbar.dart';
import 'package:shopee/features/staff/data/models/staff_model.dart';
import 'package:shopee/features/staff/domain/entities/staff.dart';
import 'package:shopee/features/staff/presentation/pages/staffdetail_tap.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:shopee/features/staff/presentation/bloc/staff_event.dart';
import 'package:shopee/features/staff/presentation/bloc/staff_state.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final ScrollController _scrollController = ScrollController();

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

  void _showSnackbar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: MediaQuery.of(context).padding.left + 16,
        child: TopOverlayWidget(
          message: message,
          onDismissed: () {
            overlayEntry?.remove();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✨ Staff "),
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
                  padding: const EdgeInsets.all(2),
                  child: BlocBuilder<StaffBloc, StaffState>(
                    builder: (context, state) {
                      if (state is StaffInitial) {
                        return const Center(
                          child: Center(
                              child: Text(
                            "Welcome to Staff page",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          )),
                        );
                      } else if (state is StaffLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is StaffLoaded) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showSnackbar(context, "Staff loaded Successfully");
                        });
                        return RefreshIndicator(
                            onRefresh: () async {
                              context.read<StaffBloc>().add(GetStaffEvent());
                            },
                            child: Center(
                              child: ListView.separated(
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
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const Divider(),
                              ),
                            ));
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
