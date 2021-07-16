import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculasapp_version2/helpers/debouncer.dart';
import 'package:peliculasapp_version2/models/models.dart';
import 'package:peliculasapp_version2/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{
  String _baseUrl = "api.themoviedb.org";
  String _apiKey = "25d31599243ac9c6e9dd94435ea96737";
  String _language = "es-ES";
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCasts = {};
  int popularPage = 0;
  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  StreamController<List<Movie>> _suggestionsController = StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream => this._suggestionsController.stream;


  MoviesProvider(){
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1])async{
    final url = Uri.https(
      _baseUrl, 
      endpoint, 
      {
        'api_key' : _apiKey,
        'language': _language,
        'page'    : '$page'
      }
    );

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies()async{
    final jsonData = await this._getJsonData("/3/movie/now_playing");
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    //print(nowPlayingResponse.results.first.title);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies()async{
    popularPage++;
    final jsonData = await _getJsonData("/3/movie/popular", popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    //print(nowPlayingResponse.results.first.title);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>>getMovieCasts(int movieId)async{
    if(movieCasts.containsKey(movieId)){
      return movieCasts[movieId]!;
    }else{
      final jsonData = await _getJsonData("/3/movie/$movieId/credits", popularPage);
      final creditsResponse = CreditsResponse.fromJson(jsonData);

      movieCasts[movieId] = creditsResponse.cast;

      return creditsResponse.cast;
    }
  }

  Future<List<Movie>>searchMovies(String query)async{
    final url = Uri.https(
      _baseUrl, 
      "/3/search/movie", 
      {
        'api_key' : _apiKey,
        'language': _language,
        'query'    : query
      }
    );

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggesionsByQuery(String searchTerm){
    debouncer.value = "";
    debouncer.onValue = (value)async{
      final result = await this.searchMovies(value);
      this._suggestionsController.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (timer) { 
      //Se obtiene el valor del query cuando el usuario ya dejó de escribir
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => {
      timer.cancel()
    });
  }
}