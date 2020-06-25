import 'package:TodoList/main.dart';
import 'package:TodoList/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String uid;
  String displayText = 'Simple TodoApp';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 40,
            child: Image(
              image: NetworkImage(
                  'https://www.hdwallpaper.nu/wp-content/uploads/2017/03/valley-16.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 50,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  '🎶Login🍉',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  displayText,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  width: 200,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text('Login'),
                    onPressed: () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        print("Login successfully!" + value.user.uid);
                        uid = value.user.uid;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp(uid)),
                        );
                      }).catchError((error) {
                        print("Falied to login!");
                        displayText = "Failed to login!";
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  width: 200,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text('Signup'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                  ),
                ),
              )
            ]),
          ),
          Expanded(
            flex: 10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      launch('https://flutter.io');
                    },
                  )
                ]),
          )
        ],
      ),
    );
  }
}
