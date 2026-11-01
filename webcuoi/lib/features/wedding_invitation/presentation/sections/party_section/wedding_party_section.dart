import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'widgets/party_section_actions.dart';
import 'widgets/wedding_calendar_card.dart';
import 'widgets/wedding_event_information.dart';
import 'widgets/wedding_page_indicator.dart';

class WeddingPartySection extends StatelessWidget {
  const WeddingPartySection({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final double targetImageWidth = 980 * scale;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: targetImageWidth),
        // AspectRatio khóa cứng tỷ lệ chuẩn 804:969 của ảnh Group_5.png,
        // giúp khung Positioned không bao giờ bị lệch khỏi tờ giấy kem
        child: AspectRatio(
          aspectRatio: 804 / 969,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double actualWidth = constraints.maxWidth;
              final double actualHeight = constraints.maxHeight;

              // Hệ số s tự động tính theo kích thước thực tế của ảnh trên màn hình
              final double s = math.max(scale, actualWidth / 804.0).toDouble();

              // Bù trừ độ lệch của cành hoa trái để tờ giấy kem nằm chính giữa trục dọc trang web
              final double paperCenterOffset = -actualWidth * 0.0398;

              return Transform.translate(
                offset: Offset(paperCenterOffset, 0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. ẢNH NỀN KHUNG HOA LÁ
                    Image.asset(
                      'assets/images/decorations/Group_5.png',
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),

                    Positioned(
                      left: actualWidth * 0.2288,
                      right: actualWidth * 0.1492,
                      top: actualHeight * 0.005,
                      child: Center(child: WeddingPageIndicator(scale: s)),
                    ),

                    // 2. VÙNG NỘI DUNG NẰM GỌN BÊN TRONG TỜ GIẤY KEM
                    // Đã lùi top xuống 7.5% và nâng bottom lên 11.5% để cách mép trên/dưới thoáng đẹp
                    Positioned(
                      left: actualWidth * 0.2288,
                      right: actualWidth * 0.1492,
                      top: actualHeight * 0.03,
                      bottom: actualHeight * 0.05,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          16 * s,
                          actualHeight * 0.08,
                          16 * s,
                          0,
                        ),
                        // FittedBox đảm bảo nội dung tự co nhẹ nếu khung bị hẹp, tuyệt đối không tràn mép
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width:
                                (actualWidth * (1 - 0.2288 - 0.1492)) -
                                (32 * s),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                WeddingEventInformation(scale: s),

                                // --- BẢNG LỊCH MÀU NÂU ---
                                SizedBox(
                                  width: actualWidth * 0.45,
                                  child: WeddingCalendarCard(scale: s),
                                ),
                                SizedBox(height: 18 * s),

                                PartySectionActions(scale: s),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
