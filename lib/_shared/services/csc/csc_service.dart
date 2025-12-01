import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_shared/services/csc/csc.dart';

const _countriesAsset = 'assets/json/countries.json';
const _statesAsset = 'assets/json/states.json';
const _citiesAsset = 'assets/json/cities.json';

List<Country> _parseCountries(String jsonString) {
  final data = jsonDecode(jsonString) as List;
  return List<Country>.from(
    data.map((i) => Country.fromJson(i as Map<String, dynamic>)),
  );
}

List<Province> _parseStates(String jsonString) {
  final data = jsonDecode(jsonString) as List;
  return List<Province>.from(
    data.map((i) => Province.fromJson(i as Map<String, dynamic>)),
  );
}

List<City> _parseCities(String jsonString) {
  final data = jsonDecode(jsonString) as List;
  return List<City>.from(
    data.map((i) => City.fromJson(i as Map<String, dynamic>)),
  );
}

/// A service to fetch and cache country, state, and city data.
/// By making it a singleton, we ensure the data is fetched only once.
final class CscService implements Disposable {
  /// A private constructor for the singleton pattern.
  CscService._();

  /// The single, static instance of the service.
  static final CscService instance = CscService._();

  List<Country> _allCountries = [];

  List<Province> _allStates = [];
  List<Province> _statesInCountry = [];

  List<City> _allCities = [];
  List<City> _citiesInState = [];

  final filteredCountries = ValueNotifier<List<Country>>([]);
  final filteredStatesInCountry = ValueNotifier<List<Province>>([]);
  final filteredCitiesInState = ValueNotifier<List<City>>([]);

  late final Command<void, void> getCountries = .createAsyncNoParamNoResult(
    () async {
      if (_allCountries.isNotEmpty) {
        filteredCountries.value = _allCountries;
        return;
      }

      final jsonString = await rootBundle.loadString(_countriesAsset);
      _allCountries = await compute(_parseCountries, jsonString);

      filteredCountries.value = _allCountries;
    },
  );

  late final Command<int, void> getStates = .createAsyncNoResult(
    (countryId) async {
      if (_allStates.isEmpty) {
        final jsonString = await rootBundle.loadString(_statesAsset);
        _allStates = await compute(_parseStates, jsonString);
      }

      final result = _allStates.where((s) => s.countryId == countryId).toList();
      result.sort((a, b) => a.name.compareTo(b.name));

      _statesInCountry = result;
      filteredStatesInCountry.value = _statesInCountry;
    },
  );

  late final Command<(int, int), void> getCities = .createAsyncNoResult(
    (params) async {
      if (_allCities.isEmpty) {
        final jsonString = await rootBundle.loadString(_citiesAsset);
        _allCities = await compute(_parseCities, jsonString);
      }

      final result = _allCities
          .where((c) => c.countryId == params.$1 && c.stateId == params.$2)
          .toList();
      result.sort((a, b) => a.name.compareTo(b.name));

      _citiesInState = result;
      filteredCitiesInState.value = _citiesInState;
    },
  );

  late final Command<String, void> searchCountries = .createAsyncNoResult(
    (keywords) async {
      final query = keywords.trim().toLowerCase();
      if (query.isEmpty) {
        filteredCountries.value = _allCountries;
      } else {
        filteredCountries.value = _allCountries.where((country) {
          return country.name.toLowerCase().contains(query);
        }).toList();
      }
    },
  );

  late final Command<String, void> searchStates = .createAsyncNoResult(
    (keywords) async {
      final query = keywords.trim().toLowerCase();
      if (query.isEmpty) {
        filteredStatesInCountry.value = _statesInCountry;
      } else {
        filteredStatesInCountry.value = _statesInCountry.where((state) {
          return state.name.toLowerCase().contains(query);
        }).toList();
      }
    },
  );

  late final Command<String, void> searchCities = .createAsyncNoResult(
    (keywords) async {
      final query = keywords.trim().toLowerCase();
      if (query.isEmpty) {
        filteredCitiesInState.value = _citiesInState;
      } else {
        filteredCitiesInState.value = _citiesInState.where((city) {
          return city.name.toLowerCase().contains(query);
        }).toList();
      }
    },
  );

  @override
  FutureOr<dynamic> onDispose() {
    getCountries.dispose();
    getStates.dispose();
    getCities.dispose();
    searchCountries.dispose();
    searchStates.dispose();
    searchCities.dispose();
    filteredCountries.dispose();
    filteredStatesInCountry.dispose();
    filteredCitiesInState.dispose();
  }
}
