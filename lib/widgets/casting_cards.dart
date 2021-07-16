import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculasapp_version2/models/models.dart';
import 'package:peliculasapp_version2/providers/movies_provider.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  CastingCards({ Key? key, required this.movieId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCasts(movieId),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if(!snapshot.hasData){
          return Container(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }else{
          final cast = snapshot.data;

          return Container(
            margin: EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cast!.length,
              itemBuilder: (BuildContext context, int i){
                return _CastCard(actor: cast[i],);
              }
            ),
          );
        }
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;
  _CastCard({ Key? key, required this.actor }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage(
                "assets/loading.gif"
              ), 
              image: NetworkImage(
                "${actor.fullProfilepath}"
              ),
              height: 140,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${actor.name}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}