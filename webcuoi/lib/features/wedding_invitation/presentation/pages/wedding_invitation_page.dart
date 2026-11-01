import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../sections/ceremony_info/ceremony_info_section.dart';
import '../sections/cover/cover_header_section.dart';
import '../sections/gift_box/gift_box_section.dart';
import '../sections/photo_gallery/photo_gallery_section.dart';
import '../sections/venue/venue_section.dart';
import '../widgets/falling_leaves_layer.dart';

class WeddingInvitationPage extends StatefulWidget {
  const WeddingInvitationPage({super.key, required this.musicPlayer});

  final AudioPlayer musicPlayer;

  @override
  State<WeddingInvitationPage> createState() => _WeddingInvitationPageState();
}

class _WeddingInvitationPageState extends State<WeddingInvitationPage> {
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isPlaying = false;
  bool _isChangingPlayback = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.musicPlayer.state == PlayerState.playing;
    _playerStateSubscription = widget.musicPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    unawaited(_playerStateSubscription?.cancel());
    unawaited(widget.musicPlayer.dispose());
    super.dispose();
  }

  Future<void> _toggleMusic() async {
    if (_isChangingPlayback) return;
    setState(() => _isChangingPlayback = true);

    try {
      final player = widget.musicPlayer;
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
      if (mounted) {
        setState(() {
          _isPlaying = widget.musicPlayer.state == PlayerState.playing;
          _isChangingPlayback = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D3BC),
      floatingActionButton: FloatingActionButton(
        onPressed: _isChangingPlayback ? null : _toggleMusic,
        tooltip: _isPlaying ? 'Tạm dừng nhạc' : 'Phát nhạc',
        backgroundColor: const Color(0xFF806D61),
        foregroundColor: Colors.white,
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: FallingLeavesLayer(count: 16)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final viewportWidth = constraints.maxWidth;
                final canvasWidth = math.min(viewportWidth, 900.0).toDouble();
                final scale = (canvasWidth / 900.0).clamp(0.72, 1.0);

                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: canvasWidth,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Keep the invitation artwork attached to the narrow
                          // invitation canvas so it scrolls with the sections.
                          // The source artwork is 900px wide and intentionally
                          // tall, matching the full-page invitation layout.
                          Image.asset(
                            'assets/images/backgrounds/mainBG.png',
                            width: canvasWidth,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            excludeFromSemantics: true,
                          ),
                          SizedBox(
                            width: canvasWidth,
                            child: Column(
                              children: [
                                CoverHeaderSection(scale: scale),
                                CeremonyInfoSection(scale: scale),
                                PhotoGallerySection(scale: scale),
                                VenueSection(scale: scale),
                                GiftBoxSection(scale: scale),
                                SizedBox(height: 80 * scale),
                              ],
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
    );
  }
}
