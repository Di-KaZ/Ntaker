import 'package:flutter/material.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/note.dart';
import 'package:n_taker/routes/note_edit.dart';
import 'package:n_taker/widgets/new_note_button.dart';
import 'package:n_taker/widgets/note_card.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  INoteProvider noteProvider = SqliteNoteProvider();
  Future<List<Note>>? notes;

  @override
  void initState() {
    notes = noteProvider.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void handleEditNotePage(int? noteId) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteEdit(
          noteId: noteId,
        ),
      ));
      setState(() {
        notes = noteProvider.getAll();
      });
    }

    return Scaffold(
      floatingActionButton:
          NewNoteButton(onPressed: () => handleEditNotePage(null)),
      appBar: AppBar(
        title: Wrap(
            spacing: 10,
            children: const [Icon(Icons.mode_edit), Text('N Taker')]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Divider(
            color: Colors.black12,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Your Notes',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Note>>(
            future: notes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('loading'));
              }
              return snapshot.data!.isEmpty
                  ? const Center(child: Text('no data'))
                  : Center(
                      child: ListNote(
                        notes: snapshot.data!,
                        onNoteTap: handleEditNotePage,
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
