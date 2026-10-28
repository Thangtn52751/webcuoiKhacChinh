import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  // Invitation sections will be added here.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
