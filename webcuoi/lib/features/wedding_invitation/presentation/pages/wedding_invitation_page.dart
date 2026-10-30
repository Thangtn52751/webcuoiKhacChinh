import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../sections/ceremony_info/ceremony_info_section.dart';
import '../sections/cover/cover_header_section.dart';
import '../sections/photo_gallery/photo_gallery_section.dart';

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
      backgroundColor: const Color(0xFFF7F1EB),
      floatingActionButton: FloatingActionButton(
        onPressed: _isChangingPlayback ? null : _toggleMusic,
        tooltip: _isPlaying
            ? 'T\u{1EA1}m d\u{1EEB}ng nh\u{1EA1}c'
            : 'Ph\u{00E1}t nh\u{1EA1}c',
        backgroundColor: const Color(0xFF806D61),
        foregroundColor: Colors.white,
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/backgrounds/mainBG.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            excludeFromSemantics: true,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Scale nội dung theo chiều rộng, giới hạn như một trang thiệp dọc.
                final contentWidth = math.min(constraints.maxWidth, 440.0);
                final scale = (contentWidth / 440.0).clamp(0.72, 1.0);

                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Column(
                        children: [
                          CoverHeaderSection(scale: scale),
                          CeremonyInfoSection(scale: scale),
                          PhotoGallerySection(scale: scale),
                          SizedBox(height: 40 * scale),
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
