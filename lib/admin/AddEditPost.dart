import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddEditPost extends StatefulWidget {
  final postList;
  final index;
  final author;

  const AddEditPost({Key key, this.postList, this.index, this.author}) : super(key: key);

  @override
  _AddEditPostState createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  File _image;
  final picker = ImagePicker();
  String selectedCategory;
  List categoryItem = [];

  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  bool editMode = false;

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  Future addEditPost() async {
    if(editMode) {
      var url = Uri.parse("http://192.168.1.252/blog_flutter/addPost.php");
      var request = await http.MultipartRequest("POST", url);
      request.fields['id'] = widget.postList[widget.index]['id'];
      request.fields['title'] = title.text;
      request.fields['body'] = body.text;
      request.fields['author'] = widget.author;
      request.fields['category_name'] = selectedCategory;

      var pic = await http.MultipartFile.fromPath(
          'image', _image.path, filename: _image.path);

      request.files.add(pic);

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Post aggiornato",
        );
        Navigator.pop(context);
        print(title.text);
      }
    }
    else{
      var url = Uri.parse("http://192.168.1.252/blog_flutter/addPost.php");
      var request = await http.MultipartRequest("POST", url);
      request.fields['title'] = title.text;
      request.fields['body'] = body.text;
      request.fields['author'] = widget.author;
      request.fields['category_name'] = selectedCategory;

      var pic = await http.MultipartFile.fromPath(
          'image', _image.path, filename: _image.path);

      request.files.add(pic);

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Post aggiornato",
        );
        Navigator.pop(context);
        print(title.text);
      }
    }
  }

  Future getAllCategory() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/categoryAll.php");
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItem = jsonData;
      });
      print(categoryItem);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCategory();
    if(widget.index != null){
      editMode = true;

      title.text = widget.postList[widget.index]['title'];
      body.text = widget.postList[widget.index]['body'];
      selectedCategory = widget.postList[widget.index]['category_name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode ? 'Update' : 'Add Post',
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Post title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: body,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Post body",
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.image,
              size: 50,
            ),
            onPressed: (){
              choiceImage();
            }
          ),
          SizedBox(
            height: 20,
          ),
          editMode
          ? Container(
            child: Image.network(
              'http://192.168.1.252/blog_flutter/uploads/${widget.postList[widget.index]['image']}'
            ),
            height: 100,
            width: 100,

          )
          : Text(
            ""
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: _image == null
              ? Center(
                  child: Text("No image selezionata"),
                )
              : Image.file(_image),
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 20,
          ),
          DropdownButton(
            items: categoryItem.map((category){
              return DropdownMenuItem(
                value: category['name'],
                child: Text(
                  category['name'],
                )
              );
            }).toList(),
            // value: selectedCategory,
            isExpanded: true,
            hint: Text("Select category"),
            onChanged: (newValue){
              setState(() {
                selectedCategory = newValue;
              });
            },
          ),
          SizedBox(height: 20,),

          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              child: Text(
                "Save post"
              ),
              onPressed: (){
                addEditPost();
              }
            ),
          )
        ],
      ),
    );
  }
}
