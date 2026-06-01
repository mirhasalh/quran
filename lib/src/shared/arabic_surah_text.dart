import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../quran/models.dart';
import '../utils.dart';

class ArabicSurahText extends StatefulWidget {
  final List<dynamic> ayahs;
  final int? activeAyahNumber;
  final ValueChanged<Ayah> onAyahTap;

  const ArabicSurahText({
    super.key,
    required this.ayahs,
    required this.activeAyahNumber,
    required this.onAyahTap,
  });

  @override
  State<ArabicSurahText> createState() => _ArabicSurahTextState();
}

class _ArabicSurahTextState extends State<ArabicSurahText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _recognizers.clear();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text.rich(
        TextSpan(
          locale: const Locale('ar'),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            height: 2.0,
            fontFamily: 'Noto Sans Arabic',
          ),
          children: widget.ayahs.map<InlineSpan>((ayah) {
            final colors = Theme.of(context).colorScheme;

            final number = convertLatinToArabic('${ayah.numberInSurah}');
            final ayahMarker = ' ﴿$number﴾';

            final recognizer = TapGestureRecognizer()
              ..onTap = () => widget.onAyahTap(ayah);
            _recognizers.add(recognizer);

            final isActive = ayah.number == widget.activeAyahNumber;

            return TextSpan(
              text: '${ayah.text}$ayahMarker ',
              style: !isActive
                  ? null
                  : TextStyle(
                      background: Paint()
                        ..color = colors.primary.withAlpha(30)
                        ..strokeWidth = 32.0
                        ..style = PaintingStyle.stroke
                        ..strokeJoin = StrokeJoin.round
                        ..strokeCap = StrokeCap.round,
                    ),
              recognizer: recognizer,
            );
          }).toList(),
        ),
      ),
    );
  }
}
