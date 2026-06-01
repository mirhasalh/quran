import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

const kBase = 'https://api.alquran.cloud';

class SurahNumber extends Cubit<int> {
  SurahNumber() : super(1);

  void setSurahNumber(int index) => emit(index);
}

class EditionId extends Cubit<String> {
  EditionId() : super('ar.alafasy');

  void setEditionId(String editionId) => emit(editionId);
}

class SurahCubit extends Cubit<Surah?> {
  SurahCubit() : super(null);

  Future<void> getSurah(int number, String edition) async {
    final url = Uri.parse('$kBase/v1/surah/$number/$edition');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);

        final Map<String, dynamic> surahData = decodedJson['data'];

        final surah = Surah.fromJson(surahData);
        emit(surah);
      } else {
        throw Exception('Failed to load surah: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching surah: $e');
      }
      emit(null);
    }
  }
}

class SurahsCubit extends Cubit<List<SurahInfo>> {
  SurahsCubit() : super([]);

  Future<void> getSurahs() async {
    final url = Uri.parse('$kBase/v1/surah');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = jsonDecode(response.body);

        final List<dynamic> surahsData = decodedJson['data'];

        final surahs = surahsData.map((e) => SurahInfo.fromJson(e)).toList();

        emit(surahs);
      } else {
        throw Exception('Failed to load surahs: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching surahs: $e');
      }
      emit([]);
    }
  }
}
