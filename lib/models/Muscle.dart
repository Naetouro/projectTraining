class Muscle {
  final int id;
  final String name;

  Muscle({this.id, this.name});

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'],
      name: json['name'],
    );
  }
}
