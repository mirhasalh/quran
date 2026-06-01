import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../quran/models.dart';
import '../quran/states.dart';

class SurahsPage extends StatefulWidget {
  static const routeName = '/surahs';

  const SurahsPage({super.key});

  @override
  State<SurahsPage> createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true),
      body: BlocBuilder<SurahsCubit, List<SurahInfo>>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  hintText: 'Search surah (e.g., Al-Faatiha)...',
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    final String query = controller.text.toLowerCase();

                    final filteredSurahs = state.where((surah) {
                      final englishName = surah.englishName!.toLowerCase();
                      final name = surah.name!.toLowerCase();
                      return englishName.contains(query) ||
                          name.contains(query);
                    }).toList();

                    if (filteredSurahs.isEmpty) {
                      return [const ListTile(title: Text('No Surahs found'))];
                    }

                    return filteredSurahs.take(5).map((surah) {
                      return ListTile(
                        subtitle: Text(surah.englishName!),
                        title: Text(
                          surah.name!,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Arabic',
                          ),
                        ),
                        trailing: Text('Ayahs: ${surah.numberOfAyahs}'),
                        onTap: () {
                          controller.closeView(surah.englishName);
                          _loadSurahAndNavigate(surah.number!);
                        },
                      );
                    }).toList();
                  },
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadSurahAndNavigate(int number) async {
    final nav = Navigator.of(context);
    final edition = context.read<EditionId>().state;
    await context.read<SurahCubit>().getSurah(number, edition);
    nav.pushNamedAndRemoveUntil('/surah', (_) => false);
  }
}
