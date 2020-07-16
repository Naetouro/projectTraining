import 'package:projecttrainingflutter/models/Exercise.dart';
import 'package:projecttrainingflutter/models/Training.dart';

class PageExercise {
  final Exercise exercise;
  final List<Training> trainingList;

  PageExercise({
    this.exercise,
    this.trainingList,
  });

  factory PageExercise.fromJson(Map<String, dynamic> json) {
    return PageExercise(
      exercise: Exercise.fromJson(json["exercise"]),
      trainingList: (json['trainingList'] as List)
          .map((data) => new Training.fromJson(data))
          .toList(),
    );
  }
}
