import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:n_taker/interfaces/icategoryprovider.dart';
import 'package:n_taker/model/category.dart';
import 'package:n_taker/widgets/categories_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ICategoryProvider categoryProvider = SqliteCategoryProvider();
  final pageSize = 5;
  final PagingController<int, Category> pagingController =
      PagingController(firstPageKey: 0);
  int? totalCategories;

  @override
  void initState() {
    pagingController.addPageRequestListener(loadPage);
    loadTotalCategories();
    super.initState();
  }

  void loadTotalCategories() async {
    var newTotal = await categoryProvider.getCount();
    setState(() {
      totalCategories = newTotal;
    });
  }

  void loadPage(int page) async {
    final categories = await categoryProvider.getPage(page, pageSize);
    final isLastPage = categories.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(categories);
    } else {
      pagingController.appendPage(categories, page + 1);
    }
  }

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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'List Categories',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ))
          ],
        ),
        Expanded(child: ListCategory(pagingController: pagingController)),
        Container(
            padding: const EdgeInsets.all(20),
            child: Text('You have ${totalCategories ?? 0} Categories',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54)))
      ],
    );
  }
}
