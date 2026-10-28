import 'package:flutter/material.dart';

import 'features/wedding_invitation/presentation/pages/wedding_cover_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thiệp cưới Khắc Chính & Thị Trang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFE8D3BC),
        fontFamily: 'Georgia',
      ),
      home: const WeddingCoverPage(),
    );
  }
}
