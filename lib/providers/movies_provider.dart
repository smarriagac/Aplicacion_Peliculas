import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';


class MoviesProvider extends ChangeNotifier {

  String _apiKey   = 'a3ee36951832386006b1da1d5fc66c5d';
  String _baseUrl  = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];

  Map<int , List<Cast>> moviesCast = {};

  int _popularPage = 0;


  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamControlle = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamControlle.stream;


  MoviesProvider(){
    print('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1] ) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key'  : _apiKey,
      'language' : _languaje,
      'page'     : '$page'
    });

  // Await the http get response, then decode the json-formatted response.
  //print(url);
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {

    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
  
  //print(nowPlayingResponse.results[0].title);
    this.onDisplayMovies = nowPlayingResponse.results;
  
    notifyListeners(); // redibuja los cambios en el arbol de widgets

  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
  
  //print(nowPlayingResponse.results[0].title);
  // desestructurar
  this.popularMovies = [...popularMovies, ...popularResponse.results];
  //print(popularMovies[0]);
  
  notifyListeners();
  }

  Future<List<Cast>> getMoviesCast(int movieId) async {

    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    //print('pidiendo info al asrvidor - cast');

    final jsonData = await this._getJsonData('3/movie/$movieId/credits'); 
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovies( String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _languaje,
      'query'     : query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson (response.body);

    return searchResponse.results;

  }

  void getSuggestionsByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value ) async {

      final result = await this.searchMovies(value);
      this._suggestionStreamControlle.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }

}