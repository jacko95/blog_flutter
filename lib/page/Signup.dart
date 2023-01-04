import 'dart:convert';

import 'package:blog_flutter_tutorial/admin/Dashboard.dart';
import 'package:blog_flutter_tutorial/page/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class SignUp extends StatefulWidget {

  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  // final _formKey = GlobalKey<FormState>();

  Future signUp() async {
    var url = Uri.parse("http://192.168.1.252/blog_flutter/register.php");
    var response = await http.post(url, body: {
      "name": name.text,
      "username": user.text,
      "password": pass.text,
    });
    if(response.statusCode == 200){
      var userData = json.decode(response.body)/*.toString()*/;
      // var userDataToStr = userData.toString();
      if(userData.toString()/*userDataToStr*/ == "Errore"){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // key: _formKey,
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
              "Utente già registrato",
            ),
            title: Text(
              "Message",
            ),
          )
        );
      }
      else{
        if(userData['status'].toString() == "Admin"){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(

                )
            ),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                  name: userData['name'].toString(),
                  email: userData['username'].toString(),

                )
            ),
          );
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // key: _formKey,
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
              "Utente registrato con successo",
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
          "Sign up",
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
                  "Sign up here",
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
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
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
            top: 330,
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
            top: 410,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                color: Colors.pink,
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: (){
                  signUp();
                },
              ),
            ),
          ),
          Positioned(
            top: 450,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "or Sign in",
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
                          builder: (context) => Login(

                          )
                      ),
                    );
                    debugPrint("CLicckk");
                  },
                  child: Text(
                    "Click me or Sign in",
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
