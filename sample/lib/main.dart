import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonURL url;
  const LoadPersonAction({required this.url}) : super();
}

enum PersonURL {
  person1URL,
  person2URL,
}

extension URLString on PersonURL {
  String get urlString {
    switch (this) {
      case PersonURL.person1URL:
        return "http://10.0.2.2:5500/lib/api/person1.json";
      case PersonURL.person2URL:
        return "http://10.0.2.2:5500/lib/api/person2.json";
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((li) => Person.fromJson(li)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() {
    return "FetchResult (isRetrievedFromCache: $isRetrievedFromCache, persons: $persons)";
  }
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonURL, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result = FetchResult(
          persons: cachedPersons,
          isRetrievedFromCache: true,
        );
        emit(result);
      } else {
        final persons = await getPersons(url.urlString);
        _cache[url] = persons;
        final result = FetchResult(
          persons: persons,
          isRetrievedFromCache: false,
        );
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Testing Cubits"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () => context.read<PersonBloc>().add(
                      const LoadPersonAction(
                        url: PersonURL.person1URL,
                      ),
                    ),
                child: const Text("Fetch Person1"),
              ),
              TextButton(
                onPressed: () => context.read<PersonBloc>().add(
                      const LoadPersonAction(
                        url: PersonURL.person2URL,
                      ),
                    ),
                child: const Text("Fetch Person2"),
              ),
            ],
          ),
          BlocBuilder<PersonBloc, FetchResult?>(
            buildWhen: (previous, current) =>
                previous?.persons != current?.persons,
            builder: (context, state) {
              final persons = state?.persons;
              if (persons == null) {
                return const SizedBox();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  final person = persons[index];
                  return ListTile(
                    title: Text(person!.name),
                    subtitle: Text("${person.age}"),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add_home_work_sharp,
        ),
      ),
    );
  }
}
