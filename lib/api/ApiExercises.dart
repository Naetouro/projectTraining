import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecttrainingflutter/constants/API.dart';
import 'package:projecttrainingflutter/models/Exercise.dart';
import 'package:projecttrainingflutter/models/pages/HomeExercise.dart';

class ApiExercises{
  Future<PageExercise> findById(idExercise) async {
    var response = await http.get('$url/exercises/$idExercise?idUser=1');

    return PageExercise.fromJson(json.decode(response.body));
  }

  Future<List<Exercise>> findAll() async {
    var response = await http.get('$url/exercises');

    return (json.decode(response.body) as List).map((data) => Exercise.fromJson(data)).toList();
  }

  Future<List<Exercise>> findAllByPrimaryMuscleId(int idMuscle) async {
    var response = await http.get('$url/muscles/$idMuscle/exercises');
    print(response.body);

    return (json.decode(response.body) as List).map((data) => Exercise.fromJson(data)).toList();
  }
}