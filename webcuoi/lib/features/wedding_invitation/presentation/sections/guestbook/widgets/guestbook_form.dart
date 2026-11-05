import 'package:flutter/material.dart';

import '../../section_theme.dart';
import 'wish_message_input.dart';

typedef GuestbookSubmit = Future<bool> Function(String name, String message);

class GuestbookForm extends StatefulWidget {
  const GuestbookForm({super.key, required this.onSubmit});

  final GuestbookSubmit onSubmit;

  @override
  State<GuestbookForm> createState() => _GuestbookFormState();
}

class _GuestbookFormState extends State<GuestbookForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _submitMessage(String message) async {
    if (!_formKey.currentState!.validate()) return false;
    final success = await widget.onSubmit(_nameController.text.trim(), message);
    if (!mounted) return false;
    if (success) {
      _nameController.clear();
      _formKey.currentState!.reset();
    }
    return success;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 439 / 578;
        final textScale = (width / 460).clamp(0.88, 1.15).toDouble();
        final inputStyle = TextStyle(
          color: SectionTheme.inkSoft,
          fontFamily: SectionTheme.fontFamily,
          fontSize: 15 * textScale,
          height: 1.2,
        );

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: width * 0.11,
                right: width * 0.005,
                top: height * 0.01,
                bottom: height * 0.01,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x01FFFFFF),
                    borderRadius: BorderRadius.circular(16 * textScale),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x285A473B),
                        blurRadius: 18 * textScale,
                        offset: Offset(0, 7 * textScale),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'assets/images/decorations/checknote_BG.png',
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
              Positioned(
                left: width * 0.17,
                right: width * 0.185,
                top: height * 0.15,
                child: Text(
                  'S\u1ED4 L\u01AFU B\u00DAT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SectionTheme.inkSoft,
                    fontFamily: SectionTheme.fontFamily,
                    fontSize: 17 * textScale,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.35 * textScale,
                  ),
                ),
              ),
              Positioned(
                left: width * 0.17,
                right: width * 0.185,
                top: height * 0.245,
                bottom: height * 0.14,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.10,
                        child: TextFormField(
                          controller: _nameController,
                          maxLength: 100,
                          style: inputStyle,
                          cursorColor: SectionTheme.inkSoft,
                          decoration: _nameDecoration(textScale),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Vui l\u00F2ng nh\u1EADp t\u00EAn.'
                              : null,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.48,
                        child: WishMessageInput(onSend: _submitMessage),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _nameDecoration(double textScale) => InputDecoration(
    hintText: 'Nh\u1EADp t\u00EAn*',
    hintStyle: TextStyle(
      color: SectionTheme.inkSoft,
      fontFamily: SectionTheme.fontFamily,
      fontSize: 14 * textScale,
    ),
    counterText: '',
    contentPadding: EdgeInsets.symmetric(
      horizontal: 10 * textScale,
      vertical: 4 * textScale,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6 * textScale),
      borderSide: BorderSide(color: SectionTheme.inkSoft, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6 * textScale),
      borderSide: BorderSide(color: SectionTheme.ink, width: 1.3),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6 * textScale),
      borderSide: const BorderSide(color: Color(0xFF9B5144), width: 0.9),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6 * textScale),
      borderSide: const BorderSide(color: Color(0xFF9B5144), width: 1.1),
    ),
    errorStyle: TextStyle(fontSize: 9 * textScale, height: 1.0),
  );
}
