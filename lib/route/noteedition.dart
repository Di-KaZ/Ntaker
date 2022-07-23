import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:n_taker/note.dart';

class NoteEdit extends StatefulWidget {
  final Note note;

  const NoteEdit({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: nameController,
        onEditingComplete: () => widget.note.name = nameController.text,
      )),
      body: Center(child: Text('hey')),
    );
  }
}
