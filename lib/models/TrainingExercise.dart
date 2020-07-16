class TrainingExercise {
  final int id;
  final String name;

  TrainingExercise({this.id, this.name});

  factory TrainingExercise.fromJson(Map<String, dynamic> json) {
    return TrainingExercise(
      id: json['id'],
      name: json['name'],
    );
  }
}
