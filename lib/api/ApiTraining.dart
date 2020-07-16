import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecttrainingflutter/constants/API.dart';
import 'package:projecttrainingflutter/models/Training.dart';

class ApiTraining {

  Future<List<Training>> findAll() async {
    var response = await http.get('$url/users/1/trainings');

    return (json.decode(response.body) as List).map((data) => Training.fromJson(data)).toList();
  }

  Future<void> save(name) async {
    await http.post('$url/users/1/trainings?name=$name');
  }

  Future<void> delete(idTraining) async {
    await http.delete('$url/users/1/trainings/$idTraining');
  }
}
