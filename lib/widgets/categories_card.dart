import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:n_taker/helper/stringhextocolor.dart';
import 'package:n_taker/interfaces/icategoryprovider.dart';
import 'package:n_taker/model/category.dart';

class ListCategory extends StatefulWidget {
  final PagingController<int, Category> pagingController;

  const ListCategory({Key? key, required this.pagingController})
      : super(key: key);

  @override
  State<ListCategory> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListCategory> {
  @override
  Widget build(BuildContext context) {
    return PagedGridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 0),
      pagingController: widget.pagingController,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      builderDelegate: PagedChildBuilderDelegate<Category>(
          itemBuilder: (context, category, index) => Center(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: HexColor.fromHex(category.color).withAlpha(50),
                  ),
                  margin: EdgeInsets.all(30),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Icon(Iconic.folder,
                            size: 40, color: HexColor.fromHex(category.color)),
                        Column(
                          children: [
                            Text(category.name),
                            Text('${category.total} Notes')
                          ],
                        )
                      ])),
                ),
              )),
    );
  }
}
