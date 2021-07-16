import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculasapp_version2/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  CardSwiper({ 
    Key? key, 
    required this.movies 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.9,
        itemBuilder: (BuildContext context, int i){
          final movie = movies[i];
          movie.heroId = "swiper-${movie.id}";
          return GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "details", arguments: movie);
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage(
                    "assets/loading.gif"
                  ),
                  image: NetworkImage(
                    "${movie.fullPosterImg}"
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}