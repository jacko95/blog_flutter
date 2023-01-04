import 'package:badges/badges.dart';
import 'package:blog_flutter_tutorial/admin/CategoryDetails.dart';
import 'package:blog_flutter_tutorial/admin/PostDetails.dart';
import 'package:blog_flutter_tutorial/page/Login.dart';
import 'package:blog_flutter_tutorial/page/UnseenNotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Dashboard extends StatefulWidget {
  final name;
  final username;

  const Dashboard({Key key, this.name = "Guest", this.username = ""}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isSeen = true;
  var total;
  var totalPost;
  var totalCategory;
  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  Future getTotalUnseenNotifications() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/selectCommentsNotification.php");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        total = response.body;
      });
    }
    print("total unread comments: " + total);
  }

  Future getTotalPost() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/totalPost.php");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        totalPost = response.body;
      });
    }
    print("total posts: " + totalPost);
  }

  Future getTotalCategory() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/totalCategory.php");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        totalCategory = response.body;
      });
    }
    print("total categories: " + totalCategory);
  }

  @override
  void initState() {
    super.initState();
    getTotalUnseenNotifications();
    getTotalPost();
    getTotalCategory();
  }


  @override
  Widget build(BuildContext context) {

    Widget menuDrawer(){
      return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.pinkAccent
              ),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                      Icons.person
                  ),
                ),
              ),
              accountName: Text(/*"Shawon"*/widget.name),
              accountEmail: Text(/*"Shawon@gmail.com"*/widget.username),
            ),
            ListTile(
              onTap: (){
                debugPrint("Home");
              },
              leading: Icon(
                Icons.home,
                color: Colors.green,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Colors.green
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryDetails(

                      )
                  ),
                );
                debugPrint("Add category");
              },
              leading: Icon(
                Icons.label,
                color: Colors.grey,
              ),
              title: Text(
                "Add category",
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetails(
                      author: widget.name,

                    )
                  ),
                );
                debugPrint("Add post");
              },
              leading: Icon(
                Icons.contacts,
                color: Colors.blue,
              ),
              title: Text(
                "Add post",
                style: TextStyle(
                    color: Colors.blue
                ),
              ),
            ),

            widget.name == "Guest"
            ? ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(

                      )
                  ),
                );
                debugPrint("Login");
              },
              leading: Icon(
                Icons.lock,
                color: Colors.red,
              ),
              title: Text(
                "Login",
                style: TextStyle(
                    color: Colors.red
                ),
              ),
            )
            : ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(

                      )
                  ),
                );
                debugPrint("Logout");
              },
              leading: Icon(
                Icons.lock_open,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: Colors.red
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
        ),
        actions: [
          isSeen? Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnseenNotificationPage(

                    )
                  ),
                ).whenComplete(() => getTotalUnseenNotifications());
                debugPrint("seen");
              },
              child: Badge(
                badgeContent: Text(
                  '$total',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                child: Icon(Icons.notifications_active),
              ),

            ),
          ) : Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){

              },
              child: Badge(
                badgeContent: Text(
                    "0"
                ),
                child: Icon(Icons.notifications_none),
              ),

            ),
          ),
        ],
      ),
      drawer: menuDrawer(),
      body: ListView(
        children: [
          myGridView(),
          Column(
            children: [
              Container(

              )
            ],
          )

        ],

      ),
    );
  }

  Widget myGridView(){
    return SingleChildScrollView(
      child: Container(
        height: 250,
        child: GridView.count(
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          padding: EdgeInsets.all(5),
          children: [
            Container(
              color: Colors.purple,
              child: Center(
                child: Text(
                    /*"Total post $totalPost\n*/"Total post: " /*+ getTotalPost().toString()*/+ totalPost,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  "Total categories: " + totalCategory,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
