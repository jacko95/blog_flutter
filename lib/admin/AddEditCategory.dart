import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddEditCategory extends StatefulWidget {
  final categoryList;
  final index;

  const AddEditCategory({Key key, this.categoryList, this.index}) : super(key: key);

  @override
  _AddEditCategoryState createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {

  bool editMode = false;
  TextEditingController categoryNameController = TextEditingController();

  Future addEditCategory() async {
    if(categoryNameController.text != ""){
      if(editMode){
        var url = Uri.parse(
            "http://192.168.1.252/blog_flutter/updateCategory.php");
        var response = await http.post(url, body: {
          "id": widget.categoryList[widget.index]['id'],
          "name": categoryNameController.text,
        });
        if (response.statusCode == 200) {
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
                "Categoria aggiornata con successo",
              ),
              title: Text(
                "Message",
              ),
            )
          );
        }
      }
      else{
        var url = Uri.parse(
            "http://192.168.1.252/blog_flutter/addCategory.php");
        var response = await http.post(url, body: {
          // "id": widget.categoryList[widget.index]['id'],
          "name": categoryNameController.text,
        });
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            msg: "Category save successful"
          );
          Navigator.pop(context);
          // showDialog(
          //   context: context,
          //   builder: (context) => AlertDialog(
          //     actions: [
          //       // ElevatedButton(
          //       //   style: ButtonStyle(
          //       //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //       //     backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          //       //   ),
          //       //   onPressed: (){
          //       //     Navigator.pop(context);
          //       //   },
          //       //   child: Text("Cancel"),
          //       // ),
          //     ],
          //     content: Text(
          //       "Categoria aggiunta con successo",
          //     ),
          //     title: Text(
          //       "Message",
          //     ),
          //   )
          // );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.index != null){
      editMode = true;
      categoryNameController.text = widget.categoryList[widget.index]['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode ? "Update" : "Add",
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: categoryNameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',

                ),
              ),
            ),
            MaterialButton(
              color: Colors.purple,
              child: Text(
                editMode ? 'Update' : "Save",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: (){
                addEditCategory();
              },
            ),
          ],
        ),
      ),
    );
  }
}
