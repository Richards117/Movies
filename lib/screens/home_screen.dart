import 'package:flutter/material.dart';
import 'package:flutter_application_2_0/search/search_delegate.dart';
import 'package:flutter_application_2_0/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            ' De_Peliculas',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.limeAccent,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    blurRadius: 5,
                    offset: Offset(1, 3),
                  )
                ]),
          )),
          elevation: 30,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: 32,
                shadows: [Shadow(color: Colors.white, blurRadius: 15)],
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.indigo.shade900),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Swiper peliculas principales
              CardSwiper(movies: moviesProvider.onDisplayMovies),

              // Slider de películas peliculas debajo de swiper
              MovieSlider(
                movies: moviesProvider.popularMovies, // populares,
                title: 'Populares', // opcional
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
            ],
          ),
        ));
  }
}
