import 'dart:convert';

import 'package:blog_flutter_tutorial/page/postDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RecentPostItem extends StatefulWidget {
  const RecentPostItem({Key key}) : super(key: key);

  @override
  _RecentPostItemState createState() => _RecentPostItemState();
}

class _RecentPostItemState extends State<RecentPostItem> {
  List recentPost = [];

  Future recentPostData() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/postAll.php");
    // var url = Uri.parse("http://localhost/blog_flutter/uploads/postAll.php");
    var response = await http.get(url);

    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      setState(() {
        recentPost = jsonData;
      });
      print(jsonData);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    recentPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: recentPost.length,
        itemBuilder: (context, index){
          return RecentItem(
            title: recentPost[index]['title'],
            author: recentPost[index]['author'],
            body: recentPost[index]['body'],
            date: recentPost[index]['create_date'],
            image: "http://192.168.1.252/blog_flutter/uploads/${recentPost[index]['image']}",
          );
        }),
    );
  }
}

class RecentItem extends StatefulWidget {
  final id;
  final title;
  final date;
  final image;
  final author;
  final body;

  const RecentItem({Key key, this.id, this.title, this.date, this.image, this.author, this.body}) : super(key: key);

  @override
  _RecentItemState createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetails(
                        title: widget.title,
                        image: widget.image,
                        body: widget.date,
                        postDate: widget.date,
                        // postDate: widget.id,
                        author: widget.author,
                      )
                    ),
                  );
                  debugPrint(widget.title);
                },
                child: Container(
                  // width: 300,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                )
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.author, style: TextStyle(color: Colors.grey),),
                Text("Posted on: " + widget.date, style: TextStyle(color: Colors.grey),),
              ],
            ),

          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Image.network(widget.image, height: 70, width: 70,),
        )
      ],
    );
  }
}

