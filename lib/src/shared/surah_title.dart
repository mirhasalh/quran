import 'package:flutter/material.dart';

class SurahTitle extends StatelessWidget {
  const SurahTitle({super.key, required this.name, required this.englishName});

  final String name;
  final String englishName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          name,
          style: textTheme.bodySmall!.copyWith(fontFamily: 'Noto Sans Arabic'),
        ),
        Text(englishName, style: textTheme.titleMedium),
      ],
    );
  }
}
