// ignore_for_file: unnecessary_const, prefer_initializing_formals

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:nextflik/main.dart';

final random = Random();

class Movie {
  final String description;
  final int id;
  final String? imageURL;
  final String title;
  final int runTime;

  const Movie(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageURL,
      required this.runTime});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imageURL: "https://image.tmdb.org/t/p/w500/${json['poster_path']}",
      description: json['overview'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
      runTime: json['runtime'] as int,
    );
  }
}

Future<Movie> fetchMovie() async {
  int id = random.nextInt(120000 - 100);

  final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/$id?language=en-US'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'Bearer ',
        HttpHeaders.acceptHeader: 'application/json'
      });
  if (response.statusCode == 200) {
    var x = Movie.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    if (seenIds.contains(x.id)) {
        return fetchMovie();
    } else {
      return x;
    }
  } else {
    return fetchMovie();
  }
}

class TinderCard extends StatelessWidget {
  final Movie movie;

  const TinderCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        width: 350,
        height: 400,
        child: Column(children: [
          Image.network(
            movie.imageURL ?? "",
            height: 200,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.purpleAccent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      softWrap: true,
                      movie.title,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      softWrap: true,
                      " | ${movie.runTime} minutes",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movie.description,
                    style: const TextStyle(color: Colors.black)),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
