import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nextflik/util/tinder_card.dart';
import 'dart:html';

List<int> matchIds = [];
List<int> seenIds = [];
Future<Movie>? futureMovie;
Movie? currentMovie;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NextFlik',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NextFlik'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  init() async {
    super.initState();
  }

  initState() {
    futureMovie = fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment:
                  CrossAxisAlignment.center, //Center Row contents vertically,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () async => {
                            if (currentMovie != null)
                              {
                                seenIds.add(currentMovie!.id),
                                setState(() {
                                  futureMovie = fetchMovie();
                                })
                              }
                          },
                      icon: const Icon(Icons.arrow_left),
                      color: Colors.purpleAccent),
                ),
                Center(
                  child: FutureBuilder<Movie>(
                    future: futureMovie,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var x = TinderCard(
                          movie: snapshot.data ??
                              const Movie(
                                  runTime: 0,
                                  id: -1,
                                  title: "",
                                  description: "",
                                  imageURL: ""),
                        );
                        currentMovie = x.movie;
                        return x;
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                //TinderCard(color: Colors.deepPurple, movie: Movie.fromJson(futureMovie)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () => {
                            if (currentMovie != null)
                              {
                                matchIds.add(currentMovie!.id),
                                seenIds.add(currentMovie!.id),
                                setState(() {
                                  futureMovie = fetchMovie();
                                }),
                                print('Movie: ${currentMovie!.title}'),
                              }
                          },
                      icon: const Icon(Icons.arrow_right),
                      color: Colors.purpleAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


var listView = ListView.builder(
      
                itemCount: matchIds.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${index}"),
                      );
                });