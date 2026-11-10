import 'package:flutter/material.dart';

import '../../../data/invitation_api.dart';
import '../section_theme.dart';

class RsvpDialog extends StatefulWidget {
  const RsvpDialog({super.key});

  @override
  State<RsvpDialog> createState() => _RsvpDialogState();
}

class _RsvpDialogState extends State<RsvpDialog> {
  static const _ink = SectionTheme.inkSoft;
  static const _muted = SectionTheme.inkSoft;
  static const _line = Color(0xFFE7E3E0);
  final _nameController = TextEditingController();
  bool? _attending;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final guestName = _nameController.text.trim();
    if (guestName.isEmpty || _attending == null || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await InvitationApi.submitRsvp(
        guestName: guestName,
        attending: _attending!,
        guestCount: _attending! ? 1 : 0,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = error is InvitationApiException
            ? error.message
            : 'Không gửi được xác nhận. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        _nameController.text.trim().isNotEmpty &&
        _attending != null &&
        !_isSubmitting;
    final fontFamily = SectionTheme.fontFamilyFor(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xác nhận tham dự',
                        style: TextStyle(
                          color: _ink,
                          fontFamily: fontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(false),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF2F3F5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: _muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Sự hiện diện của bạn là niềm vinh hạnh cho gia đình chúng tôi. Xin xác nhận để chúng tôi chuẩn bị chu đáo hơn.',
                  style: TextStyle(
                    color: _muted,
                    fontFamily: fontFamily,
                    fontSize: 10.5,
                    height: 1.45,
                    fontWeight: SectionTheme.weightFor(
                      context,
                      FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Tên của bạn',
                  style: TextStyle(
                    color: _ink,
                    fontFamily: fontFamily,
                    fontSize: 10.5,
                    fontWeight: SectionTheme.weightFor(
                      context,
                      FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Nhập tên của bạn',
                    hintStyle: TextStyle(
                      color: _muted,
                      fontFamily: fontFamily,
                      fontWeight: SectionTheme.weightFor(
                        context,
                        FontWeight.w400,
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: _ink, width: 1.2),
                    ),
                  ),
                  style: TextStyle(
                    color: _ink,
                    fontFamily: fontFamily,
                    fontSize: 11,
                    fontWeight: SectionTheme.weightFor(
                      context,
                      FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bạn sẽ đến chứ?',
                  style: TextStyle(
                    color: _ink,
                    fontFamily: fontFamily,
                    fontSize: 10.5,
                    fontWeight: SectionTheme.weightFor(
                      context,
                      FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _AttendanceOption(
                  label: 'Tôi sẽ đến',
                  icon: Icons.check_rounded,
                  selected: _attending == true,
                  onTap: () => setState(() {
                    _attending = true;
                    _error = null;
                  }),
                ),
                const SizedBox(height: 5),
                _AttendanceOption(
                  label: 'Rất tiếc, tôi không thể đến',
                  icon: Icons.close_rounded,
                  selected: _attending == false,
                  onTap: () => setState(() {
                    _attending = false;
                    _error = null;
                  }),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: _ink,
                      fontFamily: fontFamily,
                      fontSize: 11,
                      fontWeight: SectionTheme.weightFor(
                        context,
                        FontWeight.w400,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: canSubmit ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color(0xFFCDC8C4),
                      disabledForegroundColor: Colors.white,
                      backgroundColor: _ink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Gửi xác nhận',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 11,
                              fontWeight: SectionTheme.weightFor(
                                context,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceOption extends StatelessWidget {
  const _AttendanceOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF1EEEB) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          height: 39,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _RsvpDialogState._line),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: selected
                      ? _RsvpDialogState._ink
                      : const Color(0xFFE9ECEF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : _RsvpDialogState._muted,
                ),
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: _RsvpDialogState._ink,
                    fontFamily: SectionTheme.fontFamilyFor(context),
                    fontSize: 10.5,
                    fontWeight: SectionTheme.weightFor(
                      context,
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
