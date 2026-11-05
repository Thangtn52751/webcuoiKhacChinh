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
      title: 'Thiệp cưới Khắc Chính & Nguyễn Trang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFE8D3BC),
        fontFamily: 'CormorantGaramond',
        textTheme: Typography.material2018().black.apply(
          fontFamily: 'CormorantGaramond',
          bodyColor: const Color(0xFF8A7868),
          displayColor: const Color(0xFF8A7868),
        ),
      ),
      home: const WeddingCoverPage(),
    );
  }
}
