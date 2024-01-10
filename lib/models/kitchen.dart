class Kitchen {
  int? id;
  String? name;
  int? available;

  Kitchen(
      {this.id,
      this.name,
      this.available});

  factory Kitchen.fromJson(json) => Kitchen(
    id: json['id'],
    name: json['name'],
    available: json['available'],
  );

  @override
  String toString() {
    return "id: $id name: $name available: $available |";
  }
}
