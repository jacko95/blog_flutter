import 'dart:convert';

import 'package:blog_flutter_tutorial/admin/AddEditCategory.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({Key key}) : super(key: key);

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  List category = [];

  Future getAllCategory() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/categoryAll.php");
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        category = jsonData;
      });
      print(jsonData);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.add
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditCategory(
                    )
                ),
              );
            }
          ),
        ],
        title: Text(
          "Category details",

        ),
      ),
      body: ListView.builder(
        itemCount: category.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text(category[index]['name']),
              trailing: IconButton(
                onPressed: () async {
                  var url = Uri.parse(
                  "http://192.168.1.252/blog_flutter/deleteCategory.php");
                  var response = await http.post(url, body: {
                    "id": category[index]['id'],
                  });
                  if(response.statusCode == 200) {
                    // var jsonData = json.decode(response.body);
                    // setState(() {
                    //   category = jsonData;
                    // });
                    // print(jsonData);
                    // return jsonData;
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                          content: Text(
                            "Categoria cancellata con successo",
                          ),
                          title: Text(
                            "Message",
                          ),
                        )
                    );
                  }
                },
                icon: Icon(
                    Icons.delete
                ),
              ),
              leading: IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditCategory(
                        categoryList: category,
                        index: index,
                      )
                    ),
                  );
                },
                icon: Icon(
                    Icons.edit
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
