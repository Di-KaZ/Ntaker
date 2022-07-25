import 'package:flutter/material.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:n_taker/interfaces/inoteprovider.dart';
import 'package:n_taker/model/note.dart';
import 'package:n_taker/routes/category.dart';
import 'package:n_taker/routes/home.dart';
import 'package:n_taker/routes/note_edit.dart';
import 'package:n_taker/routes/settings.dart';
import 'package:n_taker/widgets/new_note_button.dart';

class Root extends StatefulWidget {
  const Root({
    Key? key,
  }) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  INoteProvider noteProvider = SqliteNoteProvider();

  final int pageSize = 5;
  final PagingController<int, Note> pagingController =
      PagingController(firstPageKey: 0);
  int screenIndex = 0;
  final options = ['Notes', 'Favorite'];
  var selectedOption = 'Notes';

  void handleTapOption(String option) {
    setState(() {
      selectedOption = option;
      pagingController.refresh();
    });
  }

  void changeSreen(int screenIdex) {
    setState(() {
      screenIndex = screenIdex;
    });
  }

  Future loadPage(int page) async {
    final notes = await noteProvider.getPage(
        page, pageSize, selectedOption == 'Favorite' ? true : null);
    final isLastPage = notes.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(notes);
    } else {
      pagingController.appendPage(notes, page + 1);
    }
  }

  @override
  void initState() {
    pagingController.removePageRequestListener(loadPage);
    pagingController.addPageRequestListener(loadPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleEditNotePage(Note? note) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NoteEdit(
          note: note ?? Note(),
        ),
      ));
      pagingController.refresh();
    }

    return Scaffold(
        floatingActionButton:
            NewNoteButton(onPressed: () => handleEditNotePage(null)),
        appBar: screenIndex != 1
            ? AppBar(
                title: Wrap(spacing: 10, children: const [
                  Icon(Icons.mode_edit),
                  Text(
                    'N Taker',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  )
                ]),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              )
            : AppBar(
                leading: Container(),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(LineariconsFree.plus_circle_1),
                  )
                ],
                title: const Center(child: Text('Categories'))),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => changeSreen(0),
                      icon: const Icon(
                        LineariconsFree.home,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => changeSreen(1),
                      icon: const Icon(
                        LineariconsFree.tag_1,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => changeSreen(2),
                      icon: const Icon(
                        LineariconsFree.cog_2,
                        size: 35,
                        color: Colors.white,
                      ),
                    )
                  ]),
            ),
          ),
        ),
        body: [
          Home(
            handleEditNotePage: handleEditNotePage,
            pageSize: pageSize,
            pagingController: pagingController,
            changelSected: handleTapOption,
            options: options,
            selectedOption: selectedOption,
          ),
          const CategoryPage(),
          const Settings(),
        ][screenIndex]);
  }
}
