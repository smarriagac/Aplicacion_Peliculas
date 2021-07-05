import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MoviesProvider extends ChangeNotifier {

  String _apiKey   = 'a3ee36951832386006b1da1d5fc66c5d';
  String _baseUrl  = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  MoviesProvider(){
    print('MoviesProvider inicializado');
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
      var url = Uri.https(_baseUrl, '3/movie/now_playing', {
        'api_key'  : _apiKey,
        'language' : _languaje,
        'page'     : '1'
      });

  // Await the http get response, then decode the json-formatted response.
  //print(url);
  final response = await http.get(url);
  final Map<String, dynamic> decodedData = json.decode(response.body);
  print(decodedData['results'][0]);

  }

}