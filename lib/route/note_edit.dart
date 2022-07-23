import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:n_taker/note.dart';

class NoteEdit extends StatefulWidget {
  final int? noteId;

  const NoteEdit({Key? key, this.noteId}) : super(key: key);

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  final nameController = TextEditingController();
  QuillController? dataController;

  Note? editingNote;

  @override
  void initState() {
    loadNote();
    super.initState();
  }

  void loadNote() async {
    var fetchedNote = widget.noteId != null
        ? (await NoteProvider().getById(widget.noteId!))
        : Note();
    setState(() {
      editingNote = fetchedNote;
      nameController.text = editingNote!.name ?? 'untiled note';
      dataController = editingNote!.data != null
          ? QuillController(
              document: Document.fromJson(jsonDecode(editingNote!.data!)),
              selection: const TextSelection.collapsed(offset: 0),
            )
          : QuillController.basic();
    });
  }

  void saveNote() async {
    editingNote!.name = nameController.text;
    editingNote!.data = jsonEncode(dataController!.document.toDelta().toJson());
    if (editingNote != null && editingNote!.id == null) {
      editingNote = await NoteProvider().insert(editingNote!);
    } else {
      NoteProvider().update(editingNote!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: editingNote != null ? saveNote : null,
              icon: const Icon(Icons.save),
            )
          ],
          title: const Center(child: Text('Edit Note'))),
      body: Center(
          child: Container(
        padding: const EdgeInsets.all(20),
        child: dataController != null
            ? Column(
                children: [
                  TextField(
                    controller: nameController,
                  ),
                  QuillEditor.basic(
                    controller: dataController!,
                    readOnly: false,
                  ),
                  QuillToolbar(
                    children: [
                      ToggleStyleButton(
                        attribute: Attribute.bold,
                        icon: Icons.format_bold,
                        controller: dataController!,
                      ),
                      ClearFormatButton(
                        controller: dataController!,
                        icon: Icons.abc,
                      )
                    ],
                  )
                ],
              )
            : const Text('loading'),
      )),
    );
  }
}
