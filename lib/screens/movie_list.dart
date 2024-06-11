import 'package:flutter/material.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/screens/movie_form.dart';
import 'package:movie_manager/screens/movie_details.dart';
import 'package:movie_manager/utils/database_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movies = await DatabaseHelper().queryAllMovies();
    setState(() {
      _movies = movies.map((movie) => Movie.fromMap(movie)).toList();
    });
  }

  void _deleteMovie(int id) async {
    await DatabaseHelper().deleteMovie(id);
    _loadMovies();
  }

  void _showMovieOptions(BuildContext context, Movie movie) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Exibir Dados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(movie: movie),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Alterar'),
              onTap: () {
                Navigator.pop(context);
                _navigateToMovieForm(movie);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToMovieForm(Movie? movie) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieForm(movie: movie),
      ),
    );
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Sobre'),
                    content: Text('Nome do grupo: Grupo X'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return Dismissible(
            key: Key(movie.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteMovie(movie.id!);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              child: ListTile(
                leading: Image.network(movie.imageUrl),
                title: Text(movie.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${movie.genre}'),
                    Text('${movie.duration}min'),
                    RatingBarIndicator(
                      rating: movie.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    _showMovieOptions(context, movie);
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToMovieForm(null),
        child: Icon(Icons.add),
      ),
    );
  }
}
