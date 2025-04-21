import 'package:flutter/material.dart';
import 'package:shopee/features/qrgen/presentation/bloc/qecode_bloc.dart';
import 'package:shopee/features/qrgen/presentation/pages/qrcode_main.dart';
import 'package:shopee/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:shopee/features/staff/domain/usecases/get_staff_list.dart';
import 'package:shopee/features/staff/domain/usecases/get_suspend_list.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:shopee/features/staff/presentation/bloc/staff_bloc.dart';

import 'package:shopee/features/quote/presentation/pages/quote_page.dart';
import 'package:shopee/features/staff/presentation/pages/staff_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Kanit'),
      title: 'Onepay+',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 5) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => QuoteBloc(),
              child: const QuotePage(),
            ),
          ));
    }

    if (_selectedIndex == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (_) => StaffBloc(
                        getStaffList: GetStaffList(StaffRepositoryImpl()),
                        getSuspendList:
                            GetSuspendStaffList(StaffRepositoryImpl())),
                    child: const StaffPage(),
                  )));
    }
    if (_selectedIndex == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (_) => QrCodeBloc(),
                    child: const QrCodePage(),
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Onepay+',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 22, 84, 255),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Placeholder(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            index: 0,
            icon: Icons.recommend_outlined,
            label: 'Stream',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
          BottomNavigationBarItem(
            index: 1,
            icon: Icons.local_mall_outlined,
            label: 'Mall',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
          BottomNavigationBarItem(
            index: 2,
            icon: Icons.videocam_outlined,
            label: 'Live',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
          BottomNavigationBarItem(
            index: 3,
            icon: Icons.qr_code,
            label: 'QrCode',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
          BottomNavigationBarItem(
            index: 4,
            icon: Icons.people_rounded,
            label: 'Staff',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
          BottomNavigationBarItem(
            index: 5,
            icon: Icons.quiz_outlined,
            label: 'Quote',
            activeColor: Color.fromARGB(255, 22, 84, 255),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationBarItem {
  const BottomNavigationBarItem({
    required this.index,
    required this.icon,
    required this.label,
    this.activeColor,
    this.color = Colors.black,
  });

  final int index;
  final IconData icon;
  final String label;
  final Color? activeColor;
  final Color color;
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.items,
  });

  final int currentIndex;
  final Function(int) onItemSelected;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          final bool isSelected = currentIndex == item.index;
          final Color color = isSelected ? item.activeColor! : item.color;
          return Expanded(
            child: InkWell(
              onTap: () => onItemSelected(item.index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: color,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
