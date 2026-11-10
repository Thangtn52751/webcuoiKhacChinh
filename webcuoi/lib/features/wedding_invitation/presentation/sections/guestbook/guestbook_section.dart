import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/guestbook_entry.dart';
import '../../../data/guestbook_repository.dart';
import '../../widgets/scroll_visibility.dart';
import '../section_theme.dart';
import 'widgets/guestbook_entry_card.dart';
import 'widgets/guestbook_form.dart';

class GuestbookSection extends StatefulWidget {
  const GuestbookSection({super.key, required this.scale});

  final double scale;

  @override
  State<GuestbookSection> createState() => _GuestbookSectionState();
}

class _GuestbookSectionState extends State<GuestbookSection> {
  static const _repository = GuestbookRepository();
  final _entryScrollController = ScrollController();

  List<GuestbookEntry> _entries = const [];
  bool _isLoading = true;
  bool _hasStartedLoading = false;
  bool _isVisible = false;
  Object? _loadError;
  late final _viewportObserver = ScrollViewportObserver(_updateVisibility);
  ScrollPosition? get _scrollPosition => _viewportObserver.position;

  @override
  void dispose() {
    _viewportObserver.dispose();
    _entryScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewportObserver.attach(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  void _updateVisibility() {
    if (!mounted) return;
    final visible = isInScrollViewport(context, _scrollPosition);
    if (visible != _isVisible) setState(() => _isVisible = visible);
    if (!visible || _hasStartedLoading) return;
    _hasStartedLoading = true;
    unawaited(_loadEntries());
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final entries = await _repository.loadEntries();
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<bool> _addEntry(String name, String message) async {
    try {
      final entry = await _repository.addEntry(name: name, message: message);
      if (!mounted) return false;
      setState(() => _entries = [entry, ..._entries]);
      _showMessage('Đã gửi lời chúc của bạn.');
      return true;
    } catch (error) {
      _showMessage('Không gửi được lời chúc. Vui lòng thử lại. ($error)');
      return false;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18 * widget.scale),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final widthFactor = isMobile ? 0.94 : 0.72;
          final formWidth = (580 * widget.scale)
              .clamp(0.0, constraints.maxWidth * widthFactor)
              .toDouble();
          final listWidth = formWidth * (isMobile ? 0.82 : 1);

          return Center(
            child: SizedBox(
              width: formWidth,
              child: Column(
                children: [
                  if (_hasStartedLoading)
                    GuestbookForm(onSubmit: _addEntry)
                  else
                    SizedBox(width: formWidth, height: formWidth * 439 / 578),
                  SizedBox(height: formWidth * 0.10),
                  Align(
                    alignment: Alignment.center,
                    child: TickerMode(
                      enabled: _isVisible,
                      child: _buildEntryList(listWidth),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEntryList(double width) {
    if (!_hasStartedLoading) {
      return SizedBox(height: 68 * widget.scale);
    }
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24 * widget.scale),
        child: SizedBox(
          width: 20 * widget.scale,
          height: 20 * widget.scale,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: SectionTheme.inkSoft,
          ),
        ),
      );
    }

    if (_loadError != null && _entries.isEmpty) {
      return Column(
        children: [
          Text(
            'Chưa tải được lời chúc.',
            textAlign: TextAlign.center,
            style: SectionTheme.body(widget.scale)
                .copyWith(color: SectionTheme.inkSoft),
          ),
          TextButton(onPressed: _loadEntries, child: const Text('Thử lại')),
        ],
      );
    }

    if (_entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 14 * widget.scale),
        child: Text(
          'Hãy là người đầu tiên gửi lời chúc.',
          textAlign: TextAlign.center,
          style: SectionTheme.body(widget.scale).copyWith(
            color: SectionTheme.inkSoft,
            fontFamily: SectionTheme.fontFamilyFor(context),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: width * 0.72,
      child: Scrollbar(
        controller: _entryScrollController,
        thumbVisibility: true,
        child: ListView.separated(
          controller: _entryScrollController,
          padding: EdgeInsets.only(right: 12 * widget.scale),
          itemCount: _entries.length,
          itemBuilder: (context, index) =>
              GuestbookEntryCard(entry: _entries[index], scale: widget.scale),
          separatorBuilder: (context, index) =>
              SizedBox(height: 8 * widget.scale),
        ),
      ),
    );
  }
}
