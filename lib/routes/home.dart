import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/note.dart';
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
  final int pageSize = 5;

  final PagingController<int, Note> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    pagingController.addPageRequestListener(loadPage);
    super.initState();
  }

  Future loadPage(int page) async {
    final notes = await noteProvider.getPage(page, pageSize);
    final isLastPage = notes.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(notes);
    } else {
      pagingController.appendPage(notes, page + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleEditNotePage(int noteId) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteEdit(
          noteId: noteId,
        ),
      ));
      pagingController.refresh();
    }

    return Scaffold(
      floatingActionButton:
          NewNoteButton(onPressed: () => handleEditNotePage(-1)),
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
          Expanded(
              child: ListNote(
            onNoteTap: handleEditNotePage,
            pagingController: pagingController,
          ))
        ],
      ),
    );
  }
}
