import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cookit_demo/delayed_animation.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:cookit_demo/service/Authentication.dart';

import 'service/RootPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Home Page',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: StartPage(),
        title: new Text(
          'CookiT',
          style: new TextStyle(
              color: Colors.white,
              backgroundColor: Colors.lightGreen,
              fontWeight: FontWeight.bold,
              fontSize: 60.0),
        ),
        backgroundColor: Colors.lightGreen,
        styleTextUnderTheLoader: new TextStyle(),
        onClick: () => print("Clicked screen"),
        loaderColor: Colors.white);
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryButton = Material(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.lightGreen,
        child: MaterialButton(
            padding: EdgeInsets.all(15.0),
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LetStart()));
            },
            child: Text(("Let's Get Started").toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                ))));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.lightGreen,
            body: Center(
                child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: Image.asset('assets/images/user_login.png'),
                ),
                AvatarGlow(
                    endRadius: 90,
                    duration: Duration(seconds: 2),
                    glowColor: Colors.white24,
                    repeat: true,
                    repeatPauseDuration: Duration(seconds: 2),
                    startDelay: Duration(seconds: 1),
                    child: Material(
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Text(
                            "CookiT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.lightGreen,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          radius: 50.0,
                        ))),
                DelayedAnimation(
                    child: Text(
                  "Hi there!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    color: Colors.white,
                  ),
                )),
                DelayedAnimation(
                    child: Text(
                  "Welcome to CookiT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0,
                    color: Colors.white,
                  ),
                )),
                SizedBox(
                  height: 30.0,
                ),
                DelayedAnimation(
                    child: Text("Your New Personal",
                        style: TextStyle(fontSize: 20.0, color: Colors.white))),
                DelayedAnimation(
                    child: Text("Cook Book",
                        style: TextStyle(fontSize: 20.0, color: Colors.white))),
                SizedBox(height: 50.0),
                primaryButton,
              ],
            ))));
  }
}

class LetStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Cookit',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
