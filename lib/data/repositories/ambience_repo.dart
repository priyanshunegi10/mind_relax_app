import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mind_relax_app/data/model/ambience_model.dart';

//
class AmbienceRepo {
  Future<List<AmbienceModel>> getAmbienceModel() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/ambiences.json',
      );

      final List<dynamic> data = jsonDecode(response);

      return data.map((json) => AmbienceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('failed to load ambience: $e');
    }
  }
}