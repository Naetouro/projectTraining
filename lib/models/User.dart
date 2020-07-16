import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier{
  String id, name, email, image;

  User({this.id, this.name, this.email, this.image});

  User.fetch(){
    fetch();
  }

  Future<void> fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = prefs.getString("id");
    this.name = prefs.getString("name");
    this.email = prefs.getString("email");
    this.image = prefs.getString("image");
    notifyListeners();
  }

}