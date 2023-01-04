import 'dart:convert';

import 'package:blog_flutter_tutorial/page/SelectCategoryBy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryListItem extends StatefulWidget {
  const CategoryListItem({Key key}) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  List categories = [];

  Future getAllCategory() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/categoryAll.php");
    var response = await http.get(url);
    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      setState(() {
        categories = jsonData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index){
          return CategoryItem(
            categoryName: categories[index]['name'],

          );
        }
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final categoryName;

  const CategoryItem({Key key, this.categoryName}) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Text(
            widget.categoryName,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18
            ),
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectCategoryBy(
                    categoryName: widget.categoryName,

                  )
              ),
            );
            debugPrint(widget.categoryName);
          },
        ),
      ),
    );
  }
}

