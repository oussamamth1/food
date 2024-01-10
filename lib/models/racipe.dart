import 'analyzed_instruction.dart';
import 'extended_ingredient.dart';

class Recipe {
  bool? vegetarian;
  bool? vegan;
  bool? glutenFree;
  bool? dairyFree;
  bool? veryHealthy;
  bool? cheap;
  bool? veryPopular;
  bool? sustainable;
  int? weightWatcherSmartPoints;
  String? gaps;
  bool? lowFodmap;
  int? aggregateLikes;
  double? spoonacularScore;
  double? healthScore;
  String? creditsText;
  String? license;
  String? sourceName;
  double? pricePerServing;
  List<ExtendedIngredient>? extendedIngredients;
  int? id;
  String? title;
  int? readyInMinutes;
  int? servings;
  String? sourceUrl;
  String? image;
  String? imageType;
  String? summary;
  List<dynamic>? cuisines;
  List<dynamic>? dishTypes;
  List<dynamic>? diets;
  List<dynamic>? occasions;
  String? instructions;
  List<AnalyzedInstruction>? analyzedInstructions;
  dynamic originalId;
  String? spoonacularSourceUrl;
  int? usedIngredientCount;
  int? missedIngredientCount;
  List<ExtendedIngredient>? missedIngredients;
  List<ExtendedIngredient>? usedIngredients;
  List<ExtendedIngredient>? unusedIngredients;
  int? likes;
  bool? eaten;

  Recipe({
    this.vegetarian,
    this.vegan,
    this.glutenFree,
    this.dairyFree,
    this.veryHealthy,
    this.cheap,
    this.veryPopular,
    this.sustainable,
    this.weightWatcherSmartPoints,
    this.gaps,
    this.lowFodmap,
    this.aggregateLikes,
    this.spoonacularScore,
    this.healthScore,
    this.creditsText,
    this.license,
    this.sourceName,
    this.pricePerServing,
    this.extendedIngredients,
    this.id,
    this.title,
    this.readyInMinutes,
    this.servings,
    this.sourceUrl,
    this.image,
    this.imageType,
    this.summary,
    this.cuisines,
    this.dishTypes,
    this.diets,
    this.occasions,
    this.instructions,
    this.analyzedInstructions,
    this.originalId,
    this.spoonacularSourceUrl,
    this.usedIngredientCount,
    this.missedIngredientCount,
    this.usedIngredients,
    this.missedIngredients,
    this.unusedIngredients,
    this.likes,
    this.eaten,
  });

  factory Recipe.fromJson(json) {
    return Recipe(
      vegetarian: json['vegetarian'] as bool?,
      vegan: json['vegan'] as bool?,
      glutenFree: json['glutenFree'] as bool?,
      dairyFree: json['dairyFree'] as bool?,
      veryHealthy: json['veryHealthy'] as bool?,
      cheap: json['cheap'] as bool?,
      veryPopular: json['veryPopular'] as bool?,
      sustainable: json['sustainable'] as bool?,
      weightWatcherSmartPoints: json['weightWatcherSmartPoints'] as int?,
      gaps: json['gaps'] as String?,
      lowFodmap: json['lowFodmap'] as bool?,
      aggregateLikes: json['aggregateLikes'] as int?,
      spoonacularScore: json['spoonacularScore'] as double? ?? 0,
      healthScore: json['healthScore'] != null
          ? double.parse(json['healthScore'].toString())
          : null,
      creditsText: json['creditsText'] as String?,
      license: json['license'] as String?,
      sourceName: json['sourceName'] as String?,
      pricePerServing: (json['pricePerServing'] as num?)?.toDouble(),
      extendedIngredients: (json['extendedIngredients'] as List<dynamic>?)
          ?.map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      id: json['id'] as int?,
      title: json['title'] as String?,
      readyInMinutes: json['readyInMinutes'] as int?,
      servings: json['servings'] as int?,
      sourceUrl: json['sourceUrl'] as String?,
      image: json['image'] as String?,
      imageType: json['imageType'] as String?,
      summary: json['summary'] as String?,
      cuisines: json['cuisines'] as List<dynamic>?,
      dishTypes: json['dishTypes'] as List<dynamic>?,
      diets: json['diets'] as List<dynamic>?,
      occasions: json['occasions'] as List<dynamic>?,
      instructions: json['instructions'] as String?,
      analyzedInstructions: (json['analyzedInstructions'] as List<dynamic>?)
          ?.map((e) => AnalyzedInstruction.fromJson(e))
          .toList(),
      originalId: json['originalId'] as dynamic,
      spoonacularSourceUrl: json['spoonacularSourceUrl'] as String?,
      usedIngredientCount: json['usedIngredientCount'] as int?,
      missedIngredientCount: json['missedIngredientCount'] as int?,
      usedIngredients: (json['usedIngredients'] as List<dynamic>?)
          ?.map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      missedIngredients: (json['missedIngredients'] as List<dynamic>?)
          ?.map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      unusedIngredients: (json['unusedIngredients'] as List<dynamic>?)
          ?.map((e) => ExtendedIngredient.fromJson(e))
          .toList(),
      likes: json['likes'] as int?,
      eaten: json['eaten'] ?? false,
    );
  }

  toJson() => {
        'vegetarian': vegetarian,
        'vegan': vegan,
        'glutenFree': glutenFree,
        'dairyFree': dairyFree,
        'veryHealthy': veryHealthy,
        'cheap': cheap,
        'veryPopular': veryPopular,
        'sustainable': sustainable,
        'weightWatcherSmartPoints': weightWatcherSmartPoints,
        'gaps': gaps,
        'lowFodmap': lowFodmap,
        'aggregateLikes': aggregateLikes,
        'spoonacularScore': spoonacularScore,
        'healthScore': healthScore,
        'creditsText': creditsText,
        'license': license,
        'sourceName': sourceName,
        'pricePerServing': pricePerServing,
        'extendedIngredients':
            extendedIngredients?.map((e) => e.toJson()).toList(),
        'id': id,
        'title': title,
        'readyInMinutes': readyInMinutes,
        'servings': servings,
        'sourceUrl': sourceUrl,
        'image': image,
        'imageType': imageType,
        'summary': summary,
        'cuisines': cuisines,
        'dishTypes': dishTypes,
        'diets': diets,
        'occasions': occasions,
        'instructions': instructions,
        'analyzedInstructions':
            analyzedInstructions?.map((e) => e.toJson()).toList(),
        'originalId': originalId,
        'spoonacularSourceUrl': spoonacularSourceUrl,
        'usedIngredientCount': usedIngredientCount,
        'missedIngredientCount': missedIngredientCount,
        'usedIngredients': usedIngredients?.map((e) => e.toJson()).toList(),
        'missedIngredients': missedIngredients?.map((e) => e.toJson()).toList(),
        'unusedIngredients': unusedIngredients?.map((e) => e.toJson()).toList(),
        'likes': likes,
        'eaten': eaten ?? false
      };
}
