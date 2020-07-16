import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/models/Training.dart';

class NotifierSelectedTraining extends ChangeNotifier {
  Training training;

  void changeTrainingValue(Training training) {
    this.training = training;
    notifyListeners();
  }
}
