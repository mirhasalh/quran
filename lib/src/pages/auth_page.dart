import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../quran/states.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _loadSurahs();
      await _loadSurahAndNavigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Future<void> _loadSurahs() async {
    await context.read<SurahsCubit>().getSurahs();
  }

  Future<void> _loadSurahAndNavigate() async {
    final nav = Navigator.of(context);
    final number = context.read<SurahNumber>().state;
    final edition = context.read<EditionId>().state;
    await context.read<SurahCubit>().getSurah(number, edition);
    nav.pushNamedAndRemoveUntil('/surah', (_) => false);
  }
}
