import 'package:flutter/material.dart';

import '../../section_theme.dart';

typedef WishMessageSend = Future<bool> Function(String message);

class WishMessageInput extends StatefulWidget {
  const WishMessageInput({super.key, required this.onSend});

  final WishMessageSend onSend;

  @override
  State<WishMessageInput> createState() => _WishMessageInputState();
}

class _WishMessageInputState extends State<WishMessageInput> {
  final _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_isSending) return;
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() => _isSending = true);
    try {
      final sent = await widget.onSend(message);
      if (!mounted) return;
      if (sent) _controller.clear();
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final buttonScale = (width / 374).clamp(0.55, 1.0).toDouble();
        final fieldScale = (width / 300).clamp(0.88, 1.0).toDouble();

        return Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                minLines: null,
                maxLength: 1000,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: SectionTheme.inkSoft,
                  fontFamily: SectionTheme.fontFamily,
                  fontSize: 14 * fieldScale,
                  height: 1.25,
                ),
                cursorColor: const Color(0xFF806F63),
                decoration: InputDecoration(
                  hintText: 'Nhập lời chúc*',
                  counterText: '',
                  hintStyle: TextStyle(
                    color: SectionTheme.inkSoft,
                    fontFamily: SectionTheme.fontFamily,
                    fontSize: 14 * fieldScale,
                  ),
                  filled: true,
                  fillColor: const Color(0x66F7F1E8),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10 * fieldScale,
                    vertical: 12 * fieldScale,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10 * fieldScale),
                    borderSide: const BorderSide(
                      color: Color(0xFF806F63),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10 * fieldScale),
                    borderSide: const BorderSide(
                      color: Color(0xFF806F63),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10 * fieldScale),
                    borderSide: const BorderSide(
                      color: Color(0xFF6D5B50),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 13 * buttonScale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * buttonScale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 161 * buttonScale,
                    height: 39 * buttonScale,
                    child: FilledButton(
                      onPressed: _isSending ? null : _send,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF806F63),
                        disabledBackgroundColor: const Color(0xFF8B796D),
                        foregroundColor: const Color(0xFFF7F1E8),
                        padding: EdgeInsets.zero,
                        shape: const StadiumBorder(),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: _isSending
                          ? SizedBox(
                              width: 15 * buttonScale,
                              height: 15 * buttonScale,
                              child: const CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: Color(0xFFF7F1E8),
                              ),
                            )
                          : Text(
                              'GỬI LỜI CHÚC',
                              style: TextStyle(
                                fontFamily: SectionTheme.fontFamily,
                                fontSize: 13 * buttonScale,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.25 * buttonScale,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
