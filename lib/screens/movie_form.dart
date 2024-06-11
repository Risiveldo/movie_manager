import 'package:flutter/material.dart';
import 'package:movie_manager/models/movie.dart';
import 'package:movie_manager/utils/database_helper.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MovieForm extends StatefulWidget {
  final Movie? movie;

  MovieForm({this.movie});

  @override
  _MovieFormState createState() => _MovieFormState();
}

class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();
  late String _imageUrl;
  late String _title;
  late String _genre;
  late String _ageRating;
  late int _duration;
  late double _rating;
  late int _year;
  late String _description;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.movie?.imageUrl ?? '';
    _title = widget.movie?.title ?? '';
    _genre = widget.movie?.genre ?? '';
    _ageRating = widget.movie?.ageRating ?? 'Livre';
    _duration = widget.movie?.duration ?? 0;
    _rating = widget.movie?.rating ?? 0.0;
    _year = widget.movie?.year ?? 0;
    _description = widget.movie?.description ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final movie = Movie(
        id: widget.movie?.id,
        imageUrl: _imageUrl,
        title: _title,
        genre: _genre,
        ageRating: _ageRating,
        duration: _duration,
        rating: _rating,
        year: _year,
        description: _description,
      );

      if (widget.movie == null) {
        DatabaseHelper().insertMovie(movie.toMap());
      } else {
        DatabaseHelper().updateMovie(movie.toMap());
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Cadastrar Filme' : 'Editar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'Url Imagem'),
                onSaved: (value) => _imageUrl = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Título'),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _genre,
                decoration: InputDecoration(labelText: 'Gênero'),
                onSaved: (value) => _genre = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o gênero';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _ageRating,
                decoration: InputDecoration(labelText: 'Faixa Etária'),
                items: ['Livre', '10', '12', '14', '16', '18']
                    .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _ageRating = value!;
                  });
                },
                onSaved: (value) => _ageRating = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a faixa etária';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _duration > 0 ? _duration.toString() : '',
                decoration: InputDecoration(labelText: 'Duração'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _duration = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a duração';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Nota:'),
              ),
              SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
                starCount: 5,
                rating: _rating,
                size: 40.0,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                color: Colors.amber,
                borderColor: Colors.amber,
                spacing: 0.0,
              ),
              TextFormField(
                initialValue: _year > 0 ? _year.toString() : '',
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _year = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 4,
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: Icon(Icons.save),
      ),
    );
  }
}
