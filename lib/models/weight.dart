class Weight {
  String? uid;
  String? day;
  String? units;
  int? weight;
  int? createdAt;
  int? updatedAt;

  Weight(
      {this.uid,
      this.day,
      this.units,
      this.weight,
      this.createdAt,
      this.updatedAt});

  factory Weight.fromJson(json) => Weight(
      uid: json['uid'],
      day: json['day'],
      units: json['units'],
      weight: json['weight'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']);

  toJson() => {
        'uid': uid,
        'day': day,
        'units': units,
        'weight': weight,
        'createdAt': createdAt ?? DateTime.now().millisecondsSinceEpoch,
        'updatedAt': updatedAt ?? DateTime.now().millisecondsSinceEpoch
      };

  @override
  String toString() {
    return "weight: $weight day: $day units: $units age: |";
  }
}
