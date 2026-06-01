import 'package:flutter/material.dart';

class PlaybackControl extends StatelessWidget {
  const PlaybackControl({
    super.key,
    required this.onChanged,
    required this.value,
    this.position,
    this.duration,
    required this.isPlaying,
    required this.onPause,
    required this.onPlay,
  });

  final Function(double) onChanged;
  final double value;
  final Duration? position;
  final Duration? duration;
  final bool isPlaying;
  final VoidCallback onPause;
  final VoidCallback onPlay;

  String get _durationText => duration?.toString().split('.').first ?? '';
  String get _positionText => position?.toString().split('.').first ?? '';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textSmall = Theme.of(context).textTheme.bodySmall;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor.withAlpha(30),
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,

      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Slider(
                  padding: EdgeInsets.zero,
                  thumbColor: colors.inverseSurface,
                  onChanged: (value) {
                    onChanged(value);
                  },
                  value: value,
                ),
                position == null
                    ? Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text('0:00:00', style: textSmall),
                          Text('0:00:00', style: textSmall),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(_positionText, style: textSmall),
                          Text(_durationText, style: textSmall),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          isPlaying
              ? IconButton.filled(
                  onPressed: onPause,
                  icon: const Icon(Icons.pause),
                )
              : IconButton.filled(
                  onPressed: onPlay,
                  icon: const Icon(Icons.play_arrow),
                ),
        ],
      ),
    );
  }
}
