import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/app.dart';
import 'src/providers.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: providers, child: const App()));
}
