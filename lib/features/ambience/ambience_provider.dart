import 'package:flutter/material.dart';
import 'package:mind_relax_app/data/model/ambience_model.dart';
import 'package:mind_relax_app/data/repositories/ambience_repo.dart';

class AmbienceProvider extends ChangeNotifier {
  final AmbienceRepo _repo = AmbienceRepo();

  List<AmbienceModel> _allAmbience = [];
  List<AmbienceModel> _filterdAmbience = [];

  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedTag = 'All';

  // getter

  List<AmbienceModel> get ambiences => _filterdAmbience;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedTag => _selectedTag;

  AmbienceProvider() {
    loadAmbience();
  }

  Future<bool> loadAmbience() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allAmbience = await _repo.getAmbienceModel();
      _filterdAmbience = _allAmbience;
      _errorMessage = '';
      return true;
    } catch (e) {
      _errorMessage = 'Error loading data. Check JSON and assets.';
      return false;
    } finally {
      _errorMessage = '';
      _isLoading = false;
      notifyListeners();
    }
  }

  // filter funtion

  void filterByTag(String tag) {
    _selectedTag = tag;
    if (tag == 'All') {
      _filterdAmbience = _allAmbience;
    } else {
      _filterdAmbience = _allAmbience.where((a) => a.tag == tag).toList();
    }
    notifyListeners();
  }

  // search option

  void search(String query) {
    if (query.isEmpty) {
      filterByTag(_selectedTag);
    } else {
      _filterdAmbience = _allAmbience.where((a) {
        final matchesTag = _selectedTag == 'All' || a.tag == _selectedTag;
        final matchesSearch = a.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        return matchesTag && matchesSearch;
      }).toList();
      notifyListeners();
    }
  }
}
