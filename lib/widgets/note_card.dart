import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:n_taker/helper/stringhextocolor.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final void Function(Note note) onTap;

  const NoteCard({Key? key, required this.note, required this.onTap})
      : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final DateFormat format = DateFormat('dd/MM/yyyy');
  final INoteProvider noteProvider = SqliteNoteProvider();

  void onFavorite() async {
    widget.note.favorite = !widget.note.favorite;
    setState(() {
      noteProvider.update(widget.note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.note),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.note.category != null
                ? HexColor.fromHex(widget.note.category!.color).withAlpha(30)
                : Colors.transparent,
            border: Border.all(
                color: widget.note.category != null
                    ? Colors.transparent
                    : Colors.black,
                width: 2)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(widget.note.name,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                IconButton(
                    color: widget.note.favorite ? Colors.yellow : Colors.black,
                    onPressed: onFavorite,
                    iconSize: 30,
                    icon: Icon(widget.note.favorite
                        ? Elusive.star
                        : LineariconsFree.star_empty))
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(widget.note.preview)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(format.format(DateTime.parse(widget.note.creation)))
            ],
          )
        ]),
      ),
    );
  }
}

class ListNote extends StatefulWidget {
  final Future<void> Function(Note note) onNoteTap;
  final PagingController<int, Note> pagingController;

  const ListNote(
      {Key? key, required this.onNoteTap, required this.pagingController})
      : super(key: key);

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  final INoteProvider noteProvider = SqliteNoteProvider();
  void onDissmissDelete(Note note) async {
    await noteProvider.delete(note.id!);
    /**
     * we need to update display of the list to refresh separator count
     * In order to avoid refreshing the whole component by calling the noteProvider
     * We update only the list currently displaying
     */
    List<Note> newItemList = List.of(widget.pagingController.itemList ?? []);
    newItemList.removeWhere((element) => element.id == note.id!);
    widget.pagingController.itemList = newItemList;
  }

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
            onDismissed: (direction) => onDissmissDelete(note),
            child: NoteCard(
              note: note,
              onTap: widget.onNoteTap,
            ),
          )),
        ));
  }
}
