// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names, unused_field
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2_0/models/models.dart';
import 'package:http/http.dart' as http;

import '../helpers/debouncer.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  //Lista Peliculas Now and Popular
  List<Movies> onDisplayMovies = [];
  List<Movies> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 400),
  );

  final StreamController<List<Movies>> _suggestionStreamContoller =
      StreamController.broadcast();
  Stream<List<Movies>> get suggestionStream =>
      _suggestionStreamContoller.stream;

  MoviesProvider() {
    print('MoviesProvider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
  }

  //Peliculas englobadas------------------
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

//Peliculas NowPlayin--------------------
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  //Peliculas Populares------------------
  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromRawJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  //Peliculas Cast------------------
  Future<List<Cast>> getMovieCast(int movieId) async {
    print('pidiendo info al servidor');
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromMap(json.decode(jsonData));

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  //Peliculas Busqueda------------------
  Future<List<Movies>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromRawJson(response.body);

    return searchResponse.results;
  }

//debouncer------------------------------------------------
  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionStreamContoller.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
