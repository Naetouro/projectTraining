import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/models/User.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<User> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user;
    if (prefs.getString("name") != null) {
      String id = prefs.getString("id");
      String name = prefs.getString("name");
      String email = prefs.getString("email");
      String image = prefs.getString("image");

      return new User(id: id, name: name, email: email, image: image);
    }

    return user;
  }

  void setUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("id", null);
    await prefs.setString('name', null);
    await prefs.setString('email', null);
    await prefs.setString('image', null);
  }

  @override
  void initState() {
    super.initState();

    _init().then((user) {
      if (user == null) {
        Future.delayed(Duration(seconds: 1, milliseconds: 500)).then((onValue) {
          Navigator.pushNamed(context, RouteLogin);
        });
      } else {
        Future.delayed(Duration(seconds: 1, milliseconds: 500)).then((onValue) {
          Navigator.pushNamed(context, RouteTraining);
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //Provider.of<User>(context).fetch();
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 150,
        ),
      ),
    );
  }
}
