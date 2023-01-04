import 'dart:convert';

import 'package:blog_flutter_tutorial/page/postDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopPostCard extends StatefulWidget {
  final userEmail;

  const TopPostCard({Key key, this.userEmail}) : super(key: key);

  @override
  _TopPostCardState createState() => _TopPostCardState();
}

class _TopPostCardState extends State<TopPostCard> {

  List postData = [];

  Future showAllPost() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/postAll.php");
    // var url = Uri.parse("http://localhost/blog_flutter/uploads/postAll.php");
    // var response = await http.get(url);
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      setState(() {
        postData = jsonData;
      });
      print(jsonData);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    showAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      // color: Colors.amber,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: postData.length == null ? CircularProgressIndicator() : postData.length,
        itemBuilder: (context, index){
          return NewPostItem(
            id: postData[index]['id'],
            userEmail: widget.userEmail,
            categoryName: postData[index]['category_name'],
            title: postData[index]['title'],
            author: postData[index]['author'],
            image: "http://192.168.1.252/blog_flutter/uploads/${postData[index]['image']}",
            body: postData[index]['body'],
            comments: postData[index]['comments'],
            createDate: postData[index]['create_date'],
            postDate: postData[index]['post_date'],
            totalLike: postData[index]['total_like'],
          );
        },
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
  final userEmail;
  final id;

  const NewPostItem({Key key, this.author, this.categoryName, this.postDate, this.title, this.body, this.comments, this.totalLike, this.image, this.createDate, this.userEmail, this.id}) : super(key: key);

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
                        id: widget.id,
                        title: widget.title,
                        image: widget.image,
                        body: widget.body,
                        postDate: widget.postDate,
                        author: widget.author,
                        userEmail: widget.userEmail,
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

