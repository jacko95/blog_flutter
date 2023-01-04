import 'dart:convert';

import 'package:blog_flutter_tutorial/admin/AddEditPost.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PostDetails extends StatefulWidget {
  final author;

  const PostDetails({Key key, this.author}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  List post = [];

  Future getAllPost() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/postAll.php");
    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        post = jsonData;
      });
      print(post);
      return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post details",

        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditPost(
                    author: widget.author,
                    // postList: post,
                    // index: index,
                  )
                ),
              ).whenComplete((){
                getAllPost();
              });
            }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index){
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  post[index]['title'],
                ),
                subtitle: Text(
                  post[index]['body'],
                  maxLines: 2,
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditPost(
                          author: widget.author,
                          index: index,
                          postList: post,
                        )
                      ),
                    ).whenComplete((){
                      getAllPost();
                    });
                  }
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                              ),
                              onPressed: () async {
                                // Navigator.pop(context);
                                var url = Uri.parse("http://192.168.1.252/blog_flutter/deletePost.php");
                                var response = await http.post(url, body: {
                                  "id": post[index]['id']
                                });
                                if(response.statusCode == 200) {
                                  Fluttertoast.showToast(msg: "Post cancellato");
                                  setState(() {
                                    getAllPost();
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Confirm"),
                            ),
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
                            "Vuoi cancellare questo post?",
                          ),
                          title: Text(
                            "Message",
                          ),
                        )
                    );
                  }
                ),
              ),
            ),
          );
        },

      ),
    );
  }

}
