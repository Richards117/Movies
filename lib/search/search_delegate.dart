import 'package:flutter/material.dart';
import 'package:flutter_application_2_0/models/models.dart';
import 'package:flutter_application_2_0/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar película';
// 1 @override ---------------------------------------
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.red,
          size: 30,
          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
        ),
        onPressed: () => query = '',
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.red),
        ),
      )
    ];
  }

// 2 @override ----------------------------------------
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
        size: 30,
        shadows: [Shadow(blurRadius: 6, color: Colors.black)],
      ),
      onPressed: () {
        close(context, null);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.yellow),
      ),
    );
  }

// 3 @override ---------------------------------------
  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black,
        size: 150,
        shadows: [Shadow(blurRadius: 100, color: Colors.indigo)],
      ),
    );
  }

// 4 @override -----------------------------------------

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movies>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _MovieItem(movies[index]));
      },
    );
  }
}

//--------MovieItem---------------------------
class _MovieItem extends StatelessWidget {
  final Movies movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.indigo, blurRadius: 8)
                ]),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.png'),
              image: NetworkImage(movie.fullPosterImg),
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        movie.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
