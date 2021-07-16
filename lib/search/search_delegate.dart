import 'package:flutter/material.dart';
import 'package:peliculasapp_version2/models/models.dart';
import 'package:provider/provider.dart';
import 'package:peliculasapp_version2/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate{
  @override
  String? get searchFieldLabel => "Buscar película";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }
  
    @override
    Widget buildLeading(BuildContext context) {
      return GestureDetector(
        onTap: (){
          close(context, null);
        },
        child: Icon(Icons.arrow_back),
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      return Text("BuildResults");
    }

    Widget _emptyContainer(){
      return Container(
        child: Center(
          child: Icon(Icons.movie_creation_outlined, color: Colors.black38,size: 130,),
        ),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      if(query.isEmpty){
        return _emptyContainer();
      }else{
        final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
        moviesProvider.getSuggesionsByQuery(query);

        return StreamBuilder(
          stream: moviesProvider.suggestionStream,
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if(!snapshot.hasData){
              return _emptyContainer();
            }else{
              final movies = snapshot.data!;

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int i){
                  return _MovieItem(movie: movies[i]);
                }
              );
            }
          },
        );
      }

    }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  _MovieItem({ Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = "search-${movie.id}";
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage(
            "assets/loading.gif"
          ), 
          image: NetworkImage(
            "${movie.fullPosterImg}"
          ),
          width: 50,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(
        movie.title
      ),
      subtitle: Text(
        movie.originalTitle
      ),
      onTap: (){
        Navigator.pushNamed(context, "details", arguments: movie);
      },
    );
  }
}