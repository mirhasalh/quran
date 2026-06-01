import 'package:flutter_bloc/flutter_bloc.dart';

import 'quran/states.dart';

final providers = <BlocProvider>[
  BlocProvider<EditionId>(create: (_) => EditionId()),
  BlocProvider<SurahNumber>(create: (_) => SurahNumber()),
  BlocProvider<SurahCubit>(create: (_) => SurahCubit()),
  BlocProvider<SurahsCubit>(create: (_) => SurahsCubit()),
];
