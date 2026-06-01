import 'package:flutter/material.dart';

import 'pages/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthPage());
    case '/surah':
      return MaterialPageRoute(builder: (_) => const SurahPage());
    case '/surahs':
      return MaterialPageRoute(builder: (_) => const SurahsPage());
    default:
      return MaterialPageRoute(
        builder: (_) => ErrorPage(route: settings.name!),
      );
  }
}
