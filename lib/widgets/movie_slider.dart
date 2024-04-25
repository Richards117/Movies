import 'package:flutter/material.dart';
import 'package:flutter_application_2_0/models/models.dart';
import 'package:flutter_application_2_0/widgets/widgets.dart';

//Parte inferior del swiper de peliculas de Home--------------------------------

class MovieSlider extends StatefulWidget {
  final Function onNextPage;
  //recibir arreglo de las peliculas-----------
  final List<Movies> movies;
  final String title;
  const MovieSlider(
      {super.key,
      required this.movies,
      required this.title,
      required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();
  //inicial
  @override
  void initState() {
    //  implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  //dispose
  @override
  void dispose() {
    //  implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 310,
      color: Colors.grey.shade300,
      child: Column(
        children: [
          //Contendor de Populares
          const PopularContainer(),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (_, int index) => _MoviePoster(
                      widget.movies[index],
                      '${widget.title}-$index-${widget.movies[index].id}',
                    )),
          ),
        ],
      ),
    );
  }
}

// Los Poster de las peliculas populares,debajo del contenedor Popualares-------
class _MoviePoster extends StatelessWidget {
  final Movies movie;
  final String heroId;
  const _MoviePoster(
    this.movie,
    this.heroId,
  );

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
        width: 125,
        height: 200,
        margin: const EdgeInsetsDirectional.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            border: Border.all(
              color: Colors.black,
              width: 2.5,
            ),
            color: Colors.grey.shade300),
//imagen dentro  de Poster de las peliculas populares---------------------------
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, 'details', arguments: movie),
                child: SingleChildScrollView(
                  child: Hero(
                    tag: movie.heroId!,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/no-image.png'),
                        image: NetworkImage(movie.fullPosterImg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              //Contenedor de titulo de peliculas populares-----------------------------------
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Center(
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: AutofillHints.addressCity,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
