import 'dart:convert';
import 'dart:ffi';

import 'package:blog_flutter_tutorial/page/AboutUs.dart';
import 'package:blog_flutter_tutorial/page/ContactUs.dart';
import 'package:blog_flutter_tutorial/page/Login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'components/CategoryListItem.dart';
import 'components/RecentPostItem.dart';
import 'components/TopPostCard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        // primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final name;
  final email;

  const MyHomePage({Key key, this.name = "Guest", this.email = ""}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var curdate = DateFormat("d MMMM y").format(DateTime.now());
  List searchList = [];

  Future showAllPost() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/postAll.php");
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      for(var i = 0; i < jsonData.length; i++){
        searchList.add(jsonData[i]['title']);
      }
      print(searchList);
      // return jsonData;
    }
  }

  @override
  void initState() {
    super.initState();
    showAllPost();
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
              accountEmail: Text(/*"Shawon@gmail.com"*/widget.email),
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
                      builder: (context) => AboutUs(

                      )
                  ),
                );
                debugPrint("About us");
              },
              leading: Icon(
                Icons.label,
                color: Colors.grey,
              ),
              title: Text(
                "About us",
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
                    builder: (context) => ContactUs(

                    )
                  ),
                );
                debugPrint("Contact us");
              },
              leading: Icon(
                Icons.contacts,
                color: Colors.amber,
              ),
              title: Text(
                "Contact us",
                style: TextStyle(
                    color: Colors.amber
                ),
              ),
            ),

            widget.name == "Guest" ? ListTile(
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search
            ),
            onPressed: (){
              showSearch(
                context: context,
                delegate: SearchPost(list: searchList),
              );
            }
          ),
        ],
      ),
      drawer: menuDrawer(
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Blogs today",
              style: TextStyle(
                fontSize: 25,
                
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  curdate,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.today,
                  color: Colors.pink,
                )
              ),
            ],
          ),
          TopPostCard(userEmail: widget.email,),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Text('Top Categories'),
            ),
          ),

          CategoryListItem(),

          RecentPostItem(),
        ],
      ),
    );
  }
}

class SearchPost extends SearchDelegate<String>{
  List<dynamic> list;

  SearchPost({this.list});

  // List searchTitle = [];

  Future showAllPost() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/searchPost.php");
    var response = await http.post(url, body: {
      'title': query
    });

    if(response.statusCode == 200){
      var jsonData = json.decode(response.body);
      return jsonData;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.close
        ),
        onPressed: (){
          query = "";
          showSuggestions(context);

        }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
          Icons.arrow_back
      ),
      onPressed: (){
        close(context, null);

      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // return Text(query);
    return FutureBuilder(
      future: showAllPost(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              var list = snapshot.data[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                      child: Text(
                        list['title'],
                        style: TextStyle(
                          fontSize: 25,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Image.network(
                        "http://192.168.1.252/blog_flutter/uploads/${list['image']}",
                        height: 250,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      list['body'] == null ? "" : list['body'],
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text(
                            "by " + list['author'],
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
                            "Posted on " + list['post_date'],
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

                              },
                            )
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          );
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listData = query.isEmpty ? list
        : list.where((element) => element.toLowerCase().contains(query)).toList();
    return listData.isEmpty ? Center(child: Text("Nessun dato")) : ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
          onTap: (){
            query = listData[index];
            showResults(context);
          },
          title: Text(
              listData[index]/*['title']*/,
          ),
        );
      }
    );
  }

}