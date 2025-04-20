import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'core/widgets/appbar.dart';
import 'core/widgets/cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopee/features/quote/bloc/quote_bloc.dart';
import 'package:shopee/features/staff/bloc/staff_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:shopee/features/quote/presentation/pages/quote_page.dart';
import 'package:shopee/features/staff/presentation/pages/staff_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shopee',
      home: MyHomePage(),
    );
  }
}

class PromotionBanner extends StatefulWidget {
  const PromotionBanner({super.key});

  @override
  _PromotionBannerState createState() => _PromotionBannerState();
}

class _PromotionBannerState extends State<PromotionBanner> {
  final PageController _pageController = PageController();
  final int _itemCount = 4;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _itemCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoSlide() {
    setState(() {});
    _timer?.cancel();
  }

  void _restartAutoSlide() {
    setState(() {});
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: 240,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              return Image.asset(
                'assets/logo/bigbanner${index + 1}.png',
                fit: BoxFit.cover,
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ดีครับ',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 160, 143, 143),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.percent,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileTab()));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chat_outlined,
                    color: Color.fromARGB(255, 255, 22, 22),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _itemCount,
            effect: const ScrollingDotsEffect(
              activeDotColor: Color.fromARGB(255, 255, 76, 22),
              dotColor: Color.fromARGB(255, 134, 134, 134),
              dotHeight: 8,
              dotWidth: 8,
              spacing: 16,
            ),
            onDotClicked: (index) {
              _stopAutoSlide();
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
              _restartAutoSlide();
            },
          ),
        ),
        const Positioned(bottom: 0, child: Mypocket()),
      ],
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
                    create: (_) => StaffBloc(),
                    child: const StaffPage(),
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: PromotionBanner(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildCategoryList(),
                const SizedBox(height: 10),
                const _MycodeState(),
                const SizedBox(height: 10),
                const ShopeeLogo(
                  textshow: 'FLASH SALE',
                  fontSize1: 20,
                ),
                const SizedBox(height: 10),
                _buildRecommendedProductList(),
                const SizedBox(height: 20),
                const ShopeeLogo(textshow: 'SHOPEE LIVE', fontSize1: 20),
                _buildShopeeLiveList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            index: 0,
            icon: Icons.recommend_outlined,
            label: 'สินค้าเเนะนำ',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
          BottomNavigationBarItem(
            index: 1,
            icon: Icons.local_mall_outlined,
            label: 'Mall',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
          BottomNavigationBarItem(
            index: 2,
            icon: Icons.videocam_outlined,
            label: 'Live',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
          BottomNavigationBarItem(
            index: 3,
            icon: Icons.slow_motion_video_rounded,
            label: 'Video',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
          BottomNavigationBarItem(
            index: 4,
            icon: Icons.notifications_on_outlined,
            label: 'การเเจ้งเตือน',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
          BottomNavigationBarItem(
            index: 5,
            icon: Icons.person_3_outlined,
            label: 'ฉัน',
            activeColor: Color.fromARGB(255, 255, 76, 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 150, // เพิ่มความสูงเพื่อให้พอสำหรับ 2 แถว
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // จำนวนคอลัมน์ในแต่ละแถว
          crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 8, // ระยะห่างระหว่างแถว
          childAspectRatio: 1.2, // อัตราส่วนของลูกค้า (สูง = กว้าง)
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print('Category ${index + 1} tapped');
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.white,
              ),
              child: Center(
                child: Column(children: [
                  SizedBox(
                    width: 30,
                    height: 40,
                    child: Image.asset(
                      'assets/category/c${index + 1}.png',
                      fit: BoxFit.contain, // ให้รูปภาพครอบคลุมพื้นที่
                    ),
                  ),
                  Text(
                    'หมวดหมู่ ${index + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedProductList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 8), // เว้นระยะห่างระหว่างการ์ด
            child: Card(
              elevation: 4, // ความสูงของเงาที่การ์ด
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // รัศมีของมุมการ์ด
              ),
              child: SizedBox(
                width: 130, // ความกว้างของการ์ด
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/products/product_image${index + 1}.png',
                          fit: BoxFit.cover, // ให้รูปภาพครอบคลุมพื้นที่
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'สินค้าแนะนำ ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
                      child: Text(
                        '฿1,000',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 76, 22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopeeLiveList() {
    return SizedBox(
      height: 240, // ความสูงของ Container ที่จะใช้สำหรับรายการ
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // เลื่อนตามแนวนอน
        itemCount: 10, // จำนวนรายการทั้งหมด
        itemBuilder: (context, index) {
          return Container(
            width: 300, // กำหนดความกว้างของแต่ละ item
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // กำหนดอัตราส่วนของรูปภาพ
                    child: Image.asset(
                      'assets/live/live${index + 1}.png',
                      fit: BoxFit.cover, // ให้รูปภาพครอบคลุมพื้นที่
                    ),
                  ),
                ),
                const SizedBox(
                    height: 8), // เพิ่มระยะห่างระหว่างรูปภาพและข้อความ
                Text(
                  'Shopee LIVE ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('กำลังไลฟ์สด...'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewProductList() {
    // Temporary widget to avoid returning null
    return Container(
      height: 200,
      color: Colors.red,
      child: const Center(
        child: Text('New products will be listed here.'),
      ),
    );
  }

  Widget _buildFeaturedProductList() {
    // Temporary widget to avoid returning null
    return Container(
      height: 200,
      color: Colors.blue,
      child: const Center(
        child: Text('Featured products will be listed here.'),
      ),
    );
  }
} //end class

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

class ShopeeLogo extends StatelessWidget {
  final String textshow;
  final double fontSize1;

  const ShopeeLogo(
      {super.key, required this.textshow, required this.fontSize1});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Text(
          textshow,
          style: TextStyle(
              fontSize: fontSize1,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 76, 22)),
        ),
        const SizedBox(width: 180),
        GestureDetector(
          onTap: () {
            print('Row tapped');
          },
          child: const Row(
            children: [
              Text(
                'ดูเพิ่มเติม',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 1),
              Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            ],
          ),
        )
      ],
    );
  }
}

class Mypocket extends StatefulWidget {
  const Mypocket({super.key});
  @override
  State<Mypocket> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Mypocket> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 45,
                  height: 30,
                  child: Center(
                    child: Icon(Icons.qr_code_scanner_rounded,
                        color: Color.fromARGB(255, 107, 104, 104)),
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Container(
                  width: 120,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: Color.fromARGB(255, 255, 76, 22)),
                        Text(
                          'ShopeePay',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text(
                          'ยิ่งใช้ ยิ่งได้ โค้ดลด 100.-',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 10,
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.monetization_on_outlined,
                            color: Color.fromARGB(255, 255, 76, 22)),
                        Text(
                          '11.80',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text(
                          'เเจก 100,000 coins',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 10,
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey,
                ),
                const SizedBox(width: 5),
                Container(
                  width: 100,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.discount_outlined,
                            color: Color.fromARGB(255, 255, 76, 22)),
                        Text(
                          '50+',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Text(
                          'โค้ดส่วนลด',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 10,
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MycodeState extends StatefulWidget {
  const _MycodeState();

  @override
  State<_MycodeState> createState() => __MycodStateState();
}

class __MycodStateState extends State<_MycodeState> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 130,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    print('Row 1 tapped');
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/popup/pop${1}.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('Row 2 tapped');
                  },
                  child: SizedBox(
                    width: 200,
                    height: 130,
                    child: Image.asset(
                      'assets/popup/pop${2}.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('Row 3 tapped');
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/popup/pop${3}.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
