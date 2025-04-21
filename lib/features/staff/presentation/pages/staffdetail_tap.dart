import 'package:flutter/material.dart';
import 'package:shopee/features/staff/domain/entities/staff.dart';
import '../../data/models/staff_model.dart';

class StaffDetail extends StatelessWidget {
  final Staff staff;

  const StaffDetail({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage:
                  AssetImage('assets/images/avatar-anika-visser.png'),
            ),
            title: Text(staff.username ?? 'No name',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(staff.email ?? 'No email'),
          ),
          const SizedBox(height: 20),
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone: ${staff.phone ?? "N/A"}'),
              Text('Position: ${staff.roleName ?? "N/A"}'),
              Text('Uid: ${staff.uid ?? "N/A"}'),
              Text('Height: ${staff.height ?? "N/A"} M'),
              Text('Ages: ${staff.age ?? "N/A"} '),
            ],
          ))
        ],
      ),
    );
  }
}
