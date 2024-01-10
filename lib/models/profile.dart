class Profile {
  String? uid;
  String? name;
  String? email;
  String? password;
  String? kitchen;
  String? units;
  double? height;
  int? desiredWeight;
  int? currentWeight;
  int? startingWeight;
  int? age;
  String? gender;
  double? bmi;
  int? mealsPerDay;
  int? objective; // 0: lose weight, 1: gain weight, 2: maintain weight
  int?
      bodyType; // 0: Pear-shaped, 1: Square-shaped, 2: Hourglass, 3: Apple-shaped, 4: Ectomorph, 5: Mesomorph, 6: Endomorph
  int?
      typicalDay; // 0: At the office, 1: Daily long  walks, 2: Physical work, 3: Mostly at home
  int?
      workout; // 0: no workout , 1: light , 2: moderate , 3: hard , 4: extra-hard , 5: extra-hard2
  List<dynamic>? allergies;
  List<dynamic>? noVegetables;
  List<dynamic>? noFruits;
  List<dynamic>? noCereals;
  List<dynamic>? noDairys;
  List<dynamic>? noMeats;
  bool? pay;
  double? idealCarbohydrate;
  double? idealProtein;
  double? idealCalory;
  double? idealFat;
  double? water;
  int? dateBegin;
  int? dateEnd;
  int? createdAt;
  int? updatedAt;

  Profile(
      {this.uid,
      this.name,
      this.email,
      this.password,
      this.kitchen,
      this.units,
      this.height,
      this.desiredWeight,
      this.currentWeight,
      this.age,
      this.gender,
      this.bmi,
      this.startingWeight,
      this.mealsPerDay,
      this.objective,
      this.bodyType,
      this.typicalDay,
      this.workout,
      this.allergies,
      this.noVegetables,
      this.noFruits,
      this.noCereals,
      this.noDairys,
      this.noMeats,
      this.pay,
      this.idealCarbohydrate,
      this.idealProtein,
      this.idealCalory,
      this.idealFat,
      this.water,
      this.dateBegin,
      this.dateEnd,
      this.createdAt,
      this.updatedAt});

  factory Profile.fromJson(json) => Profile(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      kitchen: json['kitchen'],
      units: json['units'],
      height: json['height'],
      desiredWeight: json['desiredWeight'],
      currentWeight: json['currentWeight'],
      age: json['age'],
      gender: json['gender'],
      bmi: json['bmi'],
      startingWeight: json['startingWeight'],
      mealsPerDay: json['mealsPerDay'],
      objective: json['objective'],
      bodyType: json['bodyType'],
      typicalDay: json['typicalDay'],
      workout: json['workout'],
      allergies: json['allergies'],
      noVegetables: json['noVegetables'],
      noFruits: json['noFruits'],
      noCereals: json['noCereals'],
      noDairys: json['noDairys'],
      noMeats: json['noMeats'],
      pay: json['pay'],
      idealCarbohydrate: json['idealCarbohydrate'],
      idealProtein: json['idealProtein'],
      idealCalory: json['idealCalory'],
      idealFat: json['idealFat'],
      water: json['water'],
      dateBegin: json['dateBegin'],
      dateEnd: json['dateEnd'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']);

  toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'kitchen': kitchen,
        'units': units,
        'height': height,
        'desiredWeight': desiredWeight,
        'currentWeight': currentWeight,
        'age': age,
        'gender': gender,
        'bmi': bmi,
        'startingWeight': startingWeight,
        'mealsPerDay': mealsPerDay,
        'objective': objective,
        'bodyType': bodyType,
        'typicalDay': typicalDay,
        'workout': workout,
        'allergies': allergies,
        'noVegetables': noVegetables,
        'noFruits': noFruits,
        'noCereals': noCereals,
        'noDairys': noDairys,
        'noMeats': noMeats,
        'pay': pay,
        'idealCarbohydrate': idealCarbohydrate,
        'idealProtein': idealProtein,
        'idealCalory': idealCalory,
        'idealFat': idealFat,
        'water': water,
        'dateBegin': dateBegin,
        'dateEnd': dateEnd,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };

  @override
  String toString() {
    return "name: $name kitchen: $kitchen units: $units age: $age  objective: $objective allergies: $allergies noMeats: $noMeats |";
  }
}
