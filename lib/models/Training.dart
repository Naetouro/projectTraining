class Training {
  final int id;
  final String name;

  Training({this.id, this.name});

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'],
      name: json['name'],
    );
  }
}
