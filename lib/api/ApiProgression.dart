import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:projecttrainingflutter/constants/API.dart';
import 'package:projecttrainingflutter/models/Progression.dart';
import 'package:projecttrainingflutter/models/ProgressionRecord.dart';

class ApiProgression {

  Future<List<Progression>> findAll(int idTraining, int idExercise, int nbMonths) async {
    var response = await http.get('$url/users/1/trainings/$idTraining/exercises/$idExercise/progression/lastMonths/$nbMonths');

    return (json.decode(response.body) as List).map((date) => Progression.fromJson(date)).toList();
  }

  Future<void> save(int idTraining, int idExercise, ProgressionRecord progressionRecord) async {
    await http.post('$url/users/1/trainings/$idTraining/exercises/$idExercise/progression',
        headers: {HttpHeaders.contentTypeHeader: "application/json",},
        body: json.encode(progressionRecord) );
  }

  Future<void> delete(int idTraining, int idExercise, int idProgression) async{
    await http.delete('$url/users/1/trainings/$idTraining/exercises/$idExercise/progression/$idProgression');
  }

  Future<void> update(int idTraining, int idExercise, int idProgression, int reps, double weight) async{
    await http.post('$url/users/1/trainings/$idTraining/exercises/$idExercise/progression/$idProgression',
        headers: {HttpHeaders.contentTypeHeader: "application/json",},
        body: json.encode(ProgressionRecord(reps: reps, weight:weight)) );
  }
}