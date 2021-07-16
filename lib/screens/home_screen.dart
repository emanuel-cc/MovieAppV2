import 'package:flutter/material.dart';
import 'package:peliculasapp_version2/providers/movies_provider.dart';
import 'package:peliculasapp_version2/search/search_delegate.dart';
import 'package:peliculasapp_version2/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key }) : super(key: key);
  //25d31599243ac9c6e9dd94435ea96737
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Películas"
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: (){
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            (moviesProvider.onDisplayMovies.isEmpty) ? Container(
              height: size.height * 0.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ):
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            // Slider de películas
            MovieSlider(
              title: "Populares",
              movies: moviesProvider.popularMovies,
              onNextPage: (){
                moviesProvider.getPopularMovies();
              },
            )
          ],
        ),
      ),
    );
  }
}