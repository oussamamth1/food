import 'dart:convert';

class Ingredient {
  int? id;
  int? code;
  String? name;
  String? localizedName;
  String? image;
  String? category;
  String? mainCategory;
  double? calcium;
  double? vitaminA;
  double? vitaminC;
  double? vitaminB2;
  double? water;
  double? carbohydrate;
  double? sodium;
  double? protein;
  double? calorie;
  double? fat;
  double? iron;
  double? vitaminB1;
  double? dietaryFiber;
  //double? linoleicAcid;
  //double? alphaLinolenicAcid;
  bool? eaten;
  int? servings;
  String? servingSize;
  String? type;
  List<Portion>? portions;

  Ingredient({
    this.id,
    this.name,
    this.localizedName,
    this.image,
    this.code,
    this.category,
    this.mainCategory,
    this.calcium,
    this.vitaminA,
    this.vitaminC,
    this.vitaminB2,
    this.water,
    this.carbohydrate,
    this.sodium,
    this.protein,
    this.calorie,
    this.fat,
    this.iron,
    this.vitaminB1,
    this.dietaryFiber,
    //this.linoleicAcid,
    //this.alphaLinolenicAcid,
    this.eaten,
    this.servings,
    this.servingSize,
    this.type,
    this.portions,
  });

  factory Ingredient.fromJson(jsons) {
    return Ingredient(
      id: jsons['id'] as int?,
      name: jsons['name'] as String?,
      localizedName: jsons['localizedName'] as String?,
      image: jsons['image'] as String?,
      code: jsons['code'] as int?,
      category: jsons['category'] as String?,
      mainCategory: jsons['main category'] ?? jsons['main_category'] as String?,
      calcium: jsons['calcium'] != null
          ? double.parse(jsons['calcium'].toString())
          : null,
      vitaminA: jsons['vitamin A'] != null
          ? double.parse(jsons['vitamin A'].toString())
          : null,
      vitaminC: jsons['vitamin C'] != null
          ? double.parse(jsons['vitamin C'].toString())
          : null,
      vitaminB2: jsons['vitamin B2 (riboflavin)'] != null
          ? double.parse(jsons['vitamin B2 (riboflavin)'].toString())
          : null,
      water: jsons['water'] != null
          ? double.parse(jsons['water'].toString())
          : null,
      carbohydrate: jsons['carbohydrate'] != null
          ? double.parse(jsons['carbohydrate'].toString())
          : null,
      sodium: jsons['sodium'] != null
          ? double.parse(jsons['sodium'].toString())
          : null,
      protein: jsons['protein'] != null
          ? double.parse(jsons['protein'].toString())
          : null,
      calorie: jsons['calorie'] != null
          ? double.parse(jsons['calorie'].toString())
          : 0,
      fat: jsons['fat'] != null ? double.parse(jsons['fat'].toString()) : null,
      iron:
          jsons['iron'] != null ? double.parse(jsons['iron'].toString()) : null,
      vitaminB1: jsons['vitamin B1 (thiamin)'] != null
          ? double.parse(jsons['vitamin B1 (thiamin)'].toString())
          : null,
      dietaryFiber: jsons['dietary fiber'] != null
          ? double.parse(jsons['dietary fiber'].toString())
          : null,
      //linoleicAcid: double.parse(jsons['linoleic acid'].toString()),
      //alphaLinolenicAcid: double.parse(jsons['alpha-linolenic acid'].toString()),
      eaten: jsons['eaten'] ?? false,
      servings: jsons['servings'] ?? 1,
      servingSize: jsons['servingSize'] ?? "100 g",
      type: jsons['type'],
      portions: (json.decode(jsons['portions'].toString()) as List<dynamic>?)
          ?.map((e) => Portion.fromJson(e))
          .toList(),
    );
  }

  toJson() => {
        'id': id,
        'name': name,
        'localizedName': localizedName,
        'image': image,
        'code': code,
        'category': category,
        'main category': mainCategory,
        'calcium': calcium,
        'vitamin A': vitaminA,
        'vitamin C': vitaminC,
        'vitamin B2 (riboflavin)': vitaminB2,
        'water': water,
        'carbohydrate': carbohydrate,
        'sodium': sodium,
        'protein': protein,
        'calorie': calorie,
        'fat': fat,
        'iron': iron,
        'vitamin B1 (thiamin)': vitaminB1,
        'dietary fiber': dietaryFiber,
        //'linoleic acid': linoleicAcid,
        //'alpha-linolenic acid': alphaLinolenicAcid
        'eaten': eaten ?? false,
        'servings': servings ?? 1,
        'servingSize': servingSize ?? "100 g",
        'type': type,
        'portions': json.encode(portions)
      };

  @override
  String toString() {
    return "$name  (${calorie!.round()} Kcal)";
  }
}

class Portion {
  String description;
  double weight;

  Portion({required this.description, required this.weight});

  factory Portion.fromJson(json) => Portion(
        description: json['description'],
        weight: double.tryParse(json['weight'].toString()) ?? 0.0,
      );

  toJson() => {
        'description': description,
        'weight': weight,
      };

  @override
  String toString() {
    return "$description  ($weight)";
  }
}
