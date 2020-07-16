class ProgressionRecord {
  final int id;
  final int reps;
  final double weight;

  ProgressionRecord({this.id, this.reps, this.weight});

  factory ProgressionRecord.fromJson(Map<String, dynamic> json) {
    return ProgressionRecord(id: json["id"],reps: json["reps"], weight: json["weight"]);
  }

  Map<String, dynamic> toJson(){
    return {"reps": reps, "weight": weight};
  }
}
