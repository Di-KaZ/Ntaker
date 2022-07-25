import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/note.dart';
import 'package:n_taker/widgets/note_card.dart';
import 'package:n_taker/widgets/viewBar.dart';

class Home extends StatefulWidget {
  final Future Function(Note? note) handleEditNotePage;
  final int pageSize;
  final PagingController<int, Note> pagingController;
  final List<String> options;
  final String selectedOption;
  final void Function(String options) changelSected;

  const Home(
      {Key? key,
      required this.handleEditNotePage,
      required this.pagingController,
      required this.pageSize,
      required this.options,
      required this.selectedOption,
      required this.changelSected})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  INoteProvider noteProvider = SqliteNoteProvider();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Colors.black12,
          height: 2,
          indent: 20,
          endIndent: 20,
        ),
        ViewBar(
            handleSelectOpetion: widget.changelSected,
            options: widget.options,
            selectedOption: widget.selectedOption),
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
          onNoteTap: widget.handleEditNotePage,
          pagingController: widget.pagingController,
        ))
      ],
    );
  }
}
