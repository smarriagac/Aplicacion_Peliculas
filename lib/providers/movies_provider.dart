import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';


class MoviesProvider extends ChangeNotifier {

  String _apiKey   = 'a3ee36951832386006b1da1d5fc66c5d';
  String _baseUrl  = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];
  int _popularPage = 0;

  MoviesProvider(){
    print('MoviesProvider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1] ) async {
    var url = Uri.https(_baseUrl, endpoint, {
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

}