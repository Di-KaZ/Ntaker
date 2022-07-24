import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:n_taker/model/note.dart';

class NoteEdit extends StatefulWidget {
  final int noteId;

  const NoteEdit({Key? key, required this.noteId}) : super(key: key);

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
    var fetchedNote =
        (await SqliteNoteProvider().getById(widget.noteId)) ?? Note();
    setState(() {
      nameController.text = fetchedNote.name;
      dataController = fetchedNote.data != null
          ? QuillController(
              document: Document.fromJson(jsonDecode(fetchedNote.data!)),
              selection: const TextSelection.collapsed(offset: 0),
            )
          : QuillController.basic();
      editingNote = fetchedNote;
    });
  }

  void saveNote() async {
    editingNote!.name = nameController.text;
    editingNote!.data = jsonEncode(dataController!.document.toDelta().toJson());
    var dataToText = dataController!.document.toPlainText();
    editingNote!.preview = dataToText.substring(
        0, dataToText.length < 50 ? dataToText.length : 50);
    if (editingNote!.id == null) {
      editingNote = await SqliteNoteProvider().insert(editingNote!);
    } else {
      SqliteNoteProvider().update(editingNote!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
      body: dataController != null
          ? Center(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        controller: nameController,
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: QuillEditor.basic(
                            controller: dataController!,
                            readOnly: false,
                          ),
                        ),
                      ),
                      NTakerEditTooBar(dataController: dataController!)
                    ],
                  )))
          : const Text('loading'),
    );
  }
}

class NTakerEditTooBar extends StatelessWidget {
  final QuillIconTheme iconTheme = const QuillIconTheme(
      iconUnselectedFillColor: Colors.transparent,
      iconUnselectedColor: Colors.white,
      iconSelectedColor: Colors.blue,
      iconSelectedFillColor: Colors.transparent);
  final QuillController? dataController;
  final double iconSize = 30;
  const NTakerEditTooBar({
    Key? key,
    required this.dataController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.black),
      child: QuillToolbar(
        color: Colors.transparent,
        toolbarHeight: 70,
        multiRowsDisplay: false,
        children: [
          ToggleStyleButton(
            iconSize: iconSize,
            iconTheme: iconTheme,
            attribute: Attribute.bold,
            icon: Icons.format_bold,
            controller: dataController!,
          ),
          ToggleStyleButton(
            iconSize: iconSize,
            iconTheme: iconTheme,
            attribute: Attribute.italic,
            icon: Icons.format_italic,
            controller: dataController!,
          ),
          ToggleStyleButton(
            iconSize: iconSize,
            iconTheme: iconTheme,
            attribute: Attribute.underline,
            icon: Icons.format_underline,
            controller: dataController!,
          ),
        ],
      ),
    );
  }
}
