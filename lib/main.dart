import 'package:flutter/material.dart';
import 'package:n_taker/route/noteedition.dart';
import 'package:n_taker/note.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NTaker',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const Home());
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void addNote() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteEdit(note: Note()),
      ));
    }

    return Scaffold(
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.add,
        ),
        onPressed: addNote,
        color: Colors.cyanAccent,
      ),
      appBar: AppBar(title: const Text('NTaker')),
      body: Center(
          child: FutureBuilder<List<Note>>(
        future: NoteProvider().getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('loading'));
          }
          return snapshot.data!.isEmpty
              ? const Center(child: Text('no data'))
              : ListView(
                  children: snapshot.data!
                      .map(
                        (note) => Center(
                            child: ListTile(
                          title: Text(note.name ?? 'untiled'),
                        )),
                      )
                      .toList());
        },
      )),
    );
  }
}
