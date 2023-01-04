import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Login.dart';

class PostDetails extends StatefulWidget {
  final id;
  final postDate;
  final title;
  final body;
  final image;
  final author;
  final userEmail;

  const PostDetails({Key key, this.postDate, this.title, this.body, this.image, this.author, this.userEmail = "", this.id}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  TextEditingController commentsController = TextEditingController();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String isLikeOrDislike = "";

  Future addLike() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/addLike.php");
    var response = await http.post(url, body: {
      "user_email": widget.userEmail,
      "post_id": widget.id,
    });
    if (response.statusCode == 200) {
      print("grazie");
    }
  }

  Future getLikes() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/selectLike.php");
    var response = await http.post(url, body: {
      "user_email": widget.userEmail,
      "post_id": widget.id,
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        isLikeOrDislike = data;
      });
    }
    print(isLikeOrDislike);
  }

  Future addComments() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/addComment.php");
    var response = await http.post(url, body: {
      "comment": commentsController.text,
      "user_email": widget.userEmail,
      "post_id": widget.id,
    });
    if (response.statusCode == 200) {
      // showNotification();
      Fluttertoast.showToast(
          msg: "Comment publish successful",
        fontSize: 20,
        backgroundColor: Colors.red
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

  @override
  void initState() {
    super.initState();
    getLikes();
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // var ios = IOSInitializationSettings();
    // var initialize = InitializationSettings();
    // flutterLocalNotificationsPlugin.initialize(initialize, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if(payload != null){
      debugPrint("Notification: " + payload);
    }
  }

  // Future showNotification() async {
  //   var android = AndroidNotificationDetails('channelId', 'channelName', 'channelDescription');
  //   var ios = IOSNotificationDetails();
  //   var platform = NotificationDetails(android: android, iOS: ios);
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       'blog notifica',
  //       commentsController.text,
  //       platform,
  //       payload: 'some dettagli'
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post details",

        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Image.network(
                widget.image,
                height: 150,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  widget.body == null ? "" : widget.body,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  isLikeOrDislike == "ONE" ? Padding(
                    padding: EdgeInsets.all(8),
                    child: InkWell(
                      onTap: (){
                        addLike().whenComplete(() => getLikes());
                      },
                      child: Text(
                        'Unlike',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ) : IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.green,
                    ),
                    onPressed: (){
                      if(widget.userEmail == ""){
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login(

                                        )
                                    ),
                                  );
                                },
                                child: Text("Login"),
                              ),
                            ],
                            content: Text(
                              "Prima loggati",
                            ),
                            title: Text(
                              "Message",
                            ),
                          )
                        );
                      }
                      else{
                        addLike().whenComplete(() => getLikes());
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                    ),
                    onPressed: (){

                    }
                  ),
                  InkWell(
                    child: IconButton(
                      icon: Icon(
                        Icons.share
                      ),
                    ),
                    onTap: () async {
                      await FlutterShare.share(
                        title: widget.title,
                        text: widget.body,
                        linkUrl: 'https://flutter.dev/',
                        chooserTitle: 'suppa blogggg!!!',
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "by " + widget.author,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "Posted on " + widget.postDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "Comments area",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: commentsController,
                      onSubmitted: (value){
                        commentsController.text = value;
                      },
                      onChanged: (value){
                        if(widget.userEmail == ""){
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login()
                                        ),
                                      );
                                    },
                                    child: Text("Login"),
                                  ),
                                ],
                                content: Text(
                                  "First login then comment",
                                ),
                                title: Text(
                                  "Message",
                                ),
                              )
                          );
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter comments'
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.amber,
                      child: Text(
                        "Publish",
                      ),
                      onPressed: (){
                        addComments();

                      },
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
