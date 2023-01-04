import 'dart:convert';

import 'package:blog_flutter_tutorial/page/postDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectCategoryBy extends StatefulWidget {
  final categoryName;

  const SelectCategoryBy({Key key, this.categoryName}) : super(key: key);

  @override
  _SelectCategoryByState createState() => _SelectCategoryByState();
}

class _SelectCategoryByState extends State<SelectCategoryBy> {

  List categoryByPost = [];

  Future categoryByData() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/categoryByPost.php");
    // var url = Uri.parse("http://localhost/blog_flutter/postAll.php");
    var response = await http.post(url, body: {
      'category_name': widget.categoryName,

    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryByPost = jsonData;
      });
      print(jsonData);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    categoryByData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: categoryByPost.length,
          itemBuilder: (context, index){
            return NewPostItem(
              categoryName: categoryByPost[index]['category_name'],
              title: categoryByPost[index]['title'],
              author: categoryByPost[index]['author'],
              image: "http://192.168.1.252/blog_flutter/uploads/${categoryByPost[index]['image']}",
              body: categoryByPost[index]['body'],
              comments: categoryByPost[index]['comments'],
              createDate: categoryByPost[index]['create_date'],
              postDate: categoryByPost[index]['post_date'],
              totalLike: categoryByPost[index]['total_like'],
            );
          }
        ),
      ),
    );
  }
}


class NewPostItem extends StatefulWidget {
  final categoryName;
  final author;
  final postDate;
  final title;
  final body;
  final comments;
  final totalLike;
  final image;
  final createDate;

  const NewPostItem({Key key, this.author, this.categoryName, this.postDate, this.title, this.body, this.comments, this.totalLike, this.image, this.createDate}) : super(key: key);

  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            // color: Colors.amber,
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.amber,
                      Colors.red
                    ]
                )
            ),
          ),
        ),
        Positioned(
            top: 30,
            left: 30,
            child: CircleAvatar(
              radius: 20,
              // child: Icon(Icons.person),
              backgroundImage: NetworkImage(
                  widget.image
              ),
            )
        ),
        Positioned(
          top: 30,
          left: 80,
          child: Text(
            widget.author,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 150,
          child: Text(
            widget.postDate,
            style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 100,
          child: Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: 50,
          left: 140,
          child: Text(
            widget.comments,
            style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 170,
          child: Icon(
            Icons.label,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: 50,
          left: 200,
          child: Text(
            widget.totalLike,
            style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 30,
          child: Text(
            widget.title,
            style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold
            ),

          ),
        ),
        Positioned(
            top: 146,
            left: 30,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )
        ),
        Positioned(
          top: 150,
          left: 60,
          child: InkWell(
            child: Text(
              "Read more",
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.bold
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetails(
                      title: widget.title,
                      image: widget.image,
                      body: widget.body,
                      postDate: widget.postDate,
                      author: widget.author,
                    )
                ),
              );
            },
          ),
        ),
      ],
      //),
    );
  }
}

