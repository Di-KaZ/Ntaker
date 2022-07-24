import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final void Function(int noteId) onTap;
  final DateFormat format = DateFormat('dd/MM/yyyy');
  NoteCard({Key? key, required this.note, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(note.id!),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.teal),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(note.name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(note.preview),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(format.format(DateTime.parse(note.creation)))],
          )
        ]),
      ),
    );
  }
}

class ListNote extends StatefulWidget {
  final Future<void> Function(int noteId) onNoteTap;
  final PagingController<int, Note> pagingController;

  const ListNote(
      {Key? key, required this.onNoteTap, required this.pagingController})
      : super(key: key);

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  final INoteProvider noteProvider = SqliteNoteProvider();

  @override
  Widget build(BuildContext context) {
    return PagedListView.separated(
        pagingController: widget.pagingController,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        builderDelegate: PagedChildBuilderDelegate<Note>(
          itemBuilder: (context, note, index) => Center(
              child: Dismissible(
            key: UniqueKey(),
            background: const ColoredBox(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      )),
                )),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              var removedId = await noteProvider.delete(note.id!);
              /**
               * we need to update display of the list to refresh separator count
               * In order to avoid refreshing the whole component by calling the noteProvider
               * We update only the list currently displaying
               */
              List<Note> newItemList =
                  List.of(widget.pagingController.itemList ?? []);
              newItemList.removeWhere((element) => element.id == removedId);
              widget.pagingController.itemList = newItemList;
            },
            child: NoteCard(
              note: note,
              onTap: widget.onNoteTap,
            ),
          )),
        ));
  }
}
