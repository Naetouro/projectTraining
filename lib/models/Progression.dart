import 'package:projecttrainingflutter/models/ProgressionRecord.dart';

class Progression {
  final String date;
  final List<ProgressionRecord> progressions;

  Progression({this.date, this.progressions});

  factory Progression.fromJson(Map<String, dynamic> json) {
    return Progression(
        date: json["date"],
        progressions: (json["progressions"] as List)
            .map((data) => new ProgressionRecord.fromJson(data))
            .toList());
  }
}
