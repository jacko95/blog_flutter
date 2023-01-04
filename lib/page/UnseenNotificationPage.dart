import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnseenNotificationPage extends StatefulWidget {
  const UnseenNotificationPage({Key key}) : super(key: key);

  @override
  _UnseenNotificationPageState createState() => _UnseenNotificationPageState();
}

class _UnseenNotificationPageState extends State<UnseenNotificationPage> {
  List allUnseenNotifications = [];

  Future getUnseenNotifications() async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/selectUnseenNotification.php");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        allUnseenNotifications = jsonData;
      });
    }
    print(allUnseenNotifications);
  }

  Future updateNotifications(String id) async {
    var url = Uri.parse(
        "http://192.168.1.252/blog_flutter/updateNotificationSeen.php");
    var response = await http.post(url, body: {
      "id": id
    });
    if (response.statusCode == 200) {
      print("ok");
    }
    print(allUnseenNotifications);
  }

  @override
  void initState() {
    super.initState();
    getUnseenNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notificassss"
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: allUnseenNotifications.length,
          itemBuilder: (context, index){
            var list = allUnseenNotifications[index];
            return Card(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: ListTile(
                title: Text(
                  list['comment'],
                ),
                trailing: IconButton(
                  icon: Text("Read", style: TextStyle(color: Colors.white),),
                  // icon: Icon(Icons.view_list),
                  onPressed: (){
                    updateNotifications(list['id']).whenComplete(() => getUnseenNotifications());

                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
