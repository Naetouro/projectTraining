import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecttrainingflutter/constants/API.dart';
import 'package:projecttrainingflutter/models/Exercise.dart';

class ApiTrainingExercises {

  Future<List<Exercise>> findAllByTrainingId(int idTraining) async {
    var response = await http.get('$url/users/1/trainings/$idTraining/exercises');

    return (json.decode(response.body) as List).map((data) => Exercise.fromJson(data)).toList();
  }

  Future<void> save(int idTraining, int idExercise) async{
    await http.post('$url/users/1/trainings/$idTraining/exercises/$idExercise');
  }

  Future<void> delete(int idTraining, int idExercise) async{
    await http.delete('$url/users/1/trainings/$idTraining/exercises/$idExercise');
  }
}