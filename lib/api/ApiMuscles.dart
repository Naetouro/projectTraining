import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecttrainingflutter/constants/API.dart';
import 'package:projecttrainingflutter/models/Muscle.dart';

class ApiMuscles {

  Future<List<Muscle>> findAll() async {
    var response = await http.get('$url/muscles');

    return (json.decode(response.body) as List).map((data) => Muscle.fromJson(data)).toList();
  }

  Future<void> findAll2(String token) async {
    var response = await http.get('$url/muscles?idTokenString=$token',);

  }

}