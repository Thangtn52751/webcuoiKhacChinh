import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../sections/ceremony_info/ceremony_info_section.dart';
import '../sections/cover/cover_header_section.dart';
import '../sections/gift_box/gift_box_section.dart';
import '../sections/guestbook/guestbook_section.dart';
import '../sections/photo_gallery/photo_gallery_section.dart';
import '../sections/venue/venue_section.dart';
import '../widgets/falling_leaves_layer.dart';
import '../sections/party_section/wedding_party_section.dart';
import '../sections/section_theme.dart';

class WeddingInvitationPage extends StatefulWidget {
  const WeddingInvitationPage({super.key, required this.musicPlayer});

  final AudioPlayer musicPlayer;

  @override
  State<WeddingInvitationPage> createState() => _WeddingInvitationPageState();
}

class _WeddingInvitationPageState extends State<WeddingInvitationPage>
    with WidgetsBindingObserver {
  bool _isAppResumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != null) {
      _isAppResumed = lifecycleState == AppLifecycleState.resumed;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isResumed = state == AppLifecycleState.resumed;
    if (isResumed == _isAppResumed) return;
    setState(() => _isAppResumed = isResumed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(widget.musicPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width <= 720;

    return Scaffold(
      backgroundColor: const Color(0xFFE8D3BC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _MusicPlaybackButton(player: widget.musicPlayer),
      body: TickerMode(
        enabled: _isAppResumed,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (!isMobile)
              const Positioned.fill(
                child: IgnorePointer(child: FallingLeavesLayer(count: 16)),
              ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final viewportWidth = constraints.maxWidth;
                  final canvasWidth = math.min(viewportWidth, 900.0).toDouble();
                  final scale = (canvasWidth / 900.0).clamp(0.72, 1.0);
                  final backgroundAsset = canvasWidth <= 720
                      ? 'assets/images/backgrounds/mainBG.mobile.webp'
                      : 'assets/images/backgrounds/mainBG.webp';
                  final compactTypography = SectionTheme.isCompact(context);
                  final fontFamily = SectionTheme.fontFamilyFor(context);

                  return SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: canvasWidth,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned.fill(
                              child: ClipRect(
                                child: Image.asset(
                                  backgroundAsset,
                                  width: canvasWidth,
                                  fit: canvasWidth <= 720
                                      ? BoxFit.cover
                                      : BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme
                                    .apply(fontFamily: fontFamily),
                              ),
                              child: DefaultTextStyle.merge(
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontWeight: compactTypography
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: SectionTheme.inkSoft,
                                ),
                                child: SizedBox(
                                  width: canvasWidth,
                                  child: Column(
                                    children: [
                                      CoverHeaderSection(scale: scale),
                                      CeremonyInfoSection(scale: scale),
                                      PhotoGallerySection(scale: scale),
                                      WeddingPartySection(scale: scale),
                                      // Keep the confirmed family pins for this invitation.
                                      VenueSection(
                                        scale: scale,
                                        loadFromServer: false,
                                      ),
                                      GuestbookSection(scale: scale),
                                      GiftBoxSection(scale: scale),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicPlaybackButton extends StatefulWidget {
  const _MusicPlaybackButton({required this.player});

  final AudioPlayer player;

  @override
  State<_MusicPlaybackButton> createState() => _MusicPlaybackButtonState();
}

class _MusicPlaybackButtonState extends State<_MusicPlaybackButton> {
  bool _isChangingPlayback = false;

  Future<void> _togglePlayback() async {
    if (_isChangingPlayback) return;
    setState(() => _isChangingPlayback = true);

    try {
      final player = widget.player;
      if (player.state == PlayerState.playing) {
        await player.pause();
      } else if (player.state == PlayerState.paused) {
        await player.resume();
      } else {
        await player.play(AssetSource('audio/music.mp3'));
      }
    } catch (error) {
      debugPrint('Could not change wedding music playback: $error');
    } finally {
      if (mounted) setState(() => _isChangingPlayback = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final buttonSize = isCompact ? 52.0 : 56.0;

    return StreamBuilder<PlayerState>(
      stream: widget.player.onPlayerStateChanged,
      initialData: widget.player.state,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data == PlayerState.playing;
        final label = isPlaying ? 'Tạm dừng nhạc' : 'Phát nhạc';

        return Semantics(
          button: true,
          enabled: !_isChangingPlayback,
          label: label,
          child: Tooltip(
            message: label,
            child: Material(
              color: const Color(0xFF806D61),
              shape: const CircleBorder(),
              elevation: 6,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _isChangingPlayback ? null : _togglePlayback,
                child: SizedBox.square(
                  dimension: buttonSize,
                  child: Center(
                    child: _isChangingPlayback
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: isCompact ? 24 : 26,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
