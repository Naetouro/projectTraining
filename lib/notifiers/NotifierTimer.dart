import 'package:flutter/material.dart';

class NotifierTimer extends ChangeNotifier {
  int time;
  int start;

  void changeTimeValue(int time) {
    this.time = time;
    start = time;
    notifyListeners();
  }

  void minusOne(){
    start -= 1;
    notifyListeners();
  }

}
