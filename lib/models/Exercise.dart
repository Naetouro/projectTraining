import 'package:projecttrainingflutter/models/Muscle.dart';

class Exercise {
  final int id;
  final String name;
  final String description;
  final String muscleGroup;
  final List<Muscle> primaryMuscles;
  final List<Muscle> secondaryMuscles;
  final String image;

  Exercise(
      {this.id,
      this.name,
      this.description,
      this.muscleGroup,
      this.primaryMuscles,
      this.secondaryMuscles,
      this.image});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        muscleGroup: json['muscleGroup'],
        primaryMuscles: (json['primaryMuscles'] as List)
            .map((data) => new Muscle.fromJson(data))
            .toList(),
        secondaryMuscles: (json['secondaryMuscles'] as List)
            .map((data) => new Muscle.fromJson(data))
            .toList(),
        image: json["image"]);
  }
}
