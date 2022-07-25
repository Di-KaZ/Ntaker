import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:n_taker/interfaces/icategoryprovider.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/category.dart';
import 'package:n_taker/model/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteEdit extends StatefulWidget {
  final Note note;

  const NoteEdit({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
  final INoteProvider noteProvider = SqliteNoteProvider();
  final ICategoryProvider categoryProvider = SqliteCategoryProvider();

  final nameController = TextEditingController();
  SharedPreferences? prefs;

  Note? editingNote;

  QuillController? dataController;

  List<Category> categories = [];

  Timer? autoSave;

  bool autoSaveDone = false;

  @override
  void initState() {
    loadCategories();
    loadharedPrefs();
    loadNote();
    nameController.addListener(manageAutoSaveTimer);
    super.initState();
  }

  void loadharedPrefs() async {
    var sprefs = await SharedPreferences.getInstance();
    setState(() {
      prefs = sprefs;
    });
  }

  void manageAutoSaveTimer() {
    var autosave = prefs?.getBool('autoSave');
    setState(() {
      autoSaveDone = false;
    });
    if (autosave == true) {
      if (autoSave != null) {
        autoSave!.cancel();
      }
      autoSave = Timer(const Duration(milliseconds: 1000), () {
        saveNote();
      });
    }
  }

  void loadCategories() async {
    var fetchedCategories = await categoryProvider.getAll();
    setState(() {
      categories = fetchedCategories;
    });
  }

  void loadNote() async {
    var fetchedNote =
        (await SqliteNoteProvider().getById(widget.note.id)) ?? Note();
    setState(() {
      nameController.text = fetchedNote.name;
      dataController = fetchedNote.data != null
          ? QuillController(
              document: Document.fromJson(jsonDecode(fetchedNote.data!)),
              selection: const TextSelection.collapsed(offset: 0),
            )
          : QuillController.basic();
      dataController!.addListener(manageAutoSaveTimer);
      editingNote = fetchedNote;
    });
  }

  void changeCategory(Category? category) {
    setState(() {
      editingNote!.category = category;
    });
    manageAutoSaveTimer();
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
    setState(() {
      autoSaveDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LineariconsFree.cross_circle),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: autoSaveDone ||
                      (prefs?.getBool('autoSave') != null &&
                          prefs?.getBool('autoSave') == false)
                  ? saveNote
                  : null,
              icon: Icon(prefs?.getBool('autoSave') == true && !autoSaveDone
                  ? Icons.sync
                  : LineariconsFree.checkmark_cicle),
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
                        indent: 10,
                        endIndent: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Category'),
                            DropdownButton<Category>(
                              isDense: true,
                              underline: Container(color: Colors.transparent),
                              value: editingNote!.category,
                              hint: Text('Choose'),
                              items: categories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.name),
                                      ))
                                  .toList(),
                              onChanged: changeCategory,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black12,
                        height: 1,
                        indent: 10,
                        endIndent: 10,
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
            icon: Icons.format_italic_outlined,
            controller: dataController!,
          ),
          ToggleStyleButton(
            iconSize: iconSize,
            iconTheme: iconTheme,
            attribute: Attribute.underline,
            icon: Icons.format_underline_outlined,
            controller: dataController!,
          ),
        ],
      ),
    );
  }
}
