import 'package:flutter/material.dart';
import 'package:n_taker/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final void Function(int noteId) onTap;
  const NoteCard({Key? key, required this.note, required this.onTap})
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
          Text(note.name ?? 'utiled note',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(note.data ?? ''),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(note.creation)],
          )
        ]),
      ),
    );
  }
}

class ListNote extends StatelessWidget {
  final List<Note> notes;
  final void Function(int noteId) onNoteTap;

  const ListNote({Key? key, required this.notes, required this.onNoteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: notes.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) => Center(
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
        onDismissed: (direction) => {
          SqliteNoteProvider().delete(notes[index].id!),
        },
        child: NoteCard(
          note: notes[index],
          onTap: onNoteTap,
        ),
      )),
    );
  }
}
