import 'dart:convert';

import 'package:blog_flutter_tutorial/admin/Dashboard.dart';
import 'package:blog_flutter_tutorial/main.dart';
import 'package:blog_flutter_tutorial/page/Signup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/login.php");
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });
    if(response.statusCode == 200){
      var userData = json.decode(response.body)/*.toString()*/;
      if(userData == "Errorino"){
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
              "Username and password non valide",
            ),
            title: Text(
              "Message",
            ),
          )
        );
      }
      else{
        if(userData['status'] == "Admin"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(
                name: userData['name'],
                username: userData['username'],

              )
            ),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                  name: userData['name'],
                  email: userData['username'],
                )
            ),
          );
        }
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
                "Loggato con successo",
              ),
              title: Text(
                "Message",
              ),
            )
        );
        debugPrint(userData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
        ),

      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,

          ),
          Positioned(
            top: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Login here",
                style: TextStyle(
                  fontSize: 30,

                ),
              ),
            )
          ),
          Positioned(
            top: 200,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: user,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
          ),
          Positioned(
            top: 270,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
          ),
          Positioned(
            top: 350,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: Colors.pink,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  login();
                },
              ),
            ),
          ),
          Positioned(
            top: 420,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "or Sign up",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 480,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[700]),
                    // foregroundColor: Colors.grey,
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUp(

                          )
                      ),
                    );
                    debugPrint("CLicckk");
                  },
                  child: Text(
                    "Click me or Sign up",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],

      ),
    );
  }
}
