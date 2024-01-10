import 'package:dio/dio.dart';
import 'package:fitfood/api/api_key.dart';
import 'package:fitfood/models/diet.dart';
import 'package:fitfood/models/ingredient.dart';
import 'package:fitfood/repo/ingredient_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMeal extends StatefulWidget {
  final String title;
  final String meal;
  final Diet currentDiet;
  final Function() callback;
  const AddMeal(
      {required this.title,
      required this.meal,
      required this.currentDiet,
      required this.callback,
      Key? key})
      : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  late TextEditingController controllersearch;
  bool searchedfield = false;
  late FocusNode myFocusNode;
  List<Ingredient>? ingList;
  List<Ingredient> ingListSelected = [];
  late TextEditingController controllerNumberServing;
  late TextEditingController controllerDescription;
  late TextEditingController controllerCalories;
  late TextEditingController controllerCarbs;
  late TextEditingController controllerProteins;
  late TextEditingController controllerFats;
  final _formKeyIngredientInfo = GlobalKey<FormState>();
  final _formKeyCustomEntry = GlobalKey<FormState>();
  double oldTotalFat = 0.0;
  double oldTotalCarb = 0.0;
  double oldTotalCalorie = 0.0;
  double oldTotalprotein = 0.0;

  @override
  void initState() {
    super.initState();
    controllerNumberServing = TextEditingController();
    controllerDescription = TextEditingController();
    controllerCalories = TextEditingController();
    controllerCarbs = TextEditingController();
    controllerProteins = TextEditingController();
    controllerFats = TextEditingController();
    controllersearch = TextEditingController();
    myFocusNode = FocusNode();
    if (widget.meal == "customBreakfast" &&
        widget.currentDiet.customBreakfast != null) {
      if (widget.currentDiet.customBreakfast!.isNotEmpty) {
        ingListSelected.addAll(widget.currentDiet.customBreakfast!);
        oldTotalFat = oldTotalFat +
            widget.currentDiet.customBreakfast!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.fat!.toDouble());
        oldTotalCarb = oldTotalCarb +
            widget.currentDiet.customBreakfast!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.carbohydrate!.toDouble());
        oldTotalCalorie = oldTotalCalorie +
            widget.currentDiet.customBreakfast!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.calorie!.toDouble());
        oldTotalprotein = oldTotalprotein +
            widget.currentDiet.customBreakfast!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.protein!.toDouble());
      }
    } else if (widget.meal == "customDinner" &&
        widget.currentDiet.customDinner != null) {
      if (widget.currentDiet.customDinner!.isNotEmpty) {
        ingListSelected.addAll(widget.currentDiet.customDinner!);
        oldTotalFat = oldTotalFat +
            widget.currentDiet.customDinner!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.fat!.toDouble());
        oldTotalCarb = oldTotalCarb +
            widget.currentDiet.customDinner!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.carbohydrate!.toDouble());
        oldTotalCalorie = oldTotalCalorie +
            widget.currentDiet.customDinner!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.calorie!.toDouble());
        oldTotalprotein = oldTotalprotein +
            widget.currentDiet.customDinner!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.protein!.toDouble());
      }
    } else if (widget.meal == "customLunch" &&
        widget.currentDiet.customLunch != null) {
      if (widget.currentDiet.customLunch!.isNotEmpty) {
        ingListSelected.addAll(widget.currentDiet.customLunch!);
        oldTotalFat = oldTotalFat +
            widget.currentDiet.customLunch!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.fat!.toDouble());
        oldTotalCarb = oldTotalCarb +
            widget.currentDiet.customLunch!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.carbohydrate!.toDouble());
        oldTotalCalorie = oldTotalCalorie +
            widget.currentDiet.customLunch!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.calorie!.toDouble());
        oldTotalprotein = oldTotalprotein +
            widget.currentDiet.customLunch!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.protein!.toDouble());
      }
    } else if (widget.meal == "customSnack1" &&
        widget.currentDiet.customSnack1 != null) {
      if (widget.currentDiet.customSnack1!.isNotEmpty) {
        ingListSelected.addAll(widget.currentDiet.customSnack1!);
        oldTotalFat = oldTotalFat +
            widget.currentDiet.customSnack1!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.fat!.toDouble());
        oldTotalCarb = oldTotalCarb +
            widget.currentDiet.customSnack1!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.carbohydrate!.toDouble());
        oldTotalCalorie = oldTotalCalorie +
            widget.currentDiet.customSnack1!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.calorie!.toDouble());
        oldTotalprotein = oldTotalprotein +
            widget.currentDiet.customSnack1!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.protein!.toDouble());
      }
    } else if (widget.meal == "customSnack2" &&
        widget.currentDiet.customSnack2 != null) {
      if (widget.currentDiet.customSnack2!.isNotEmpty) {
        ingListSelected.addAll(widget.currentDiet.customSnack2!);
        oldTotalFat = oldTotalFat +
            widget.currentDiet.customSnack2!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.fat!.toDouble());
        oldTotalCarb = oldTotalCarb +
            widget.currentDiet.customSnack2!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.carbohydrate!.toDouble());
        oldTotalCalorie = oldTotalCalorie +
            widget.currentDiet.customSnack2!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.calorie!.toDouble());
        oldTotalprotein = oldTotalprotein +
            widget.currentDiet.customSnack2!.fold(
                0.0,
                (num previousValue, element) =>
                    previousValue + element.protein!.toDouble());
      }
    }
  }

  @override
  void dispose() {
    controllersearch.dispose();
    myFocusNode.dispose();
    controllerNumberServing.dispose();
    controllerDescription.dispose();
    controllerCalories.dispose();
    controllerCarbs.dispose();
    controllerProteins.dispose();
    controllerFats.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          bottom: PreferredSize(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(
                        top: 5, bottom: 10, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade400,
                        )),
                    child: TextFormField(
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: !searchedfield
                            ? const Icon(Icons.search)
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchedfield = false;
                                    myFocusNode.unfocus();
                                    controllersearch.text = "";
                                  });
                                },
                                icon: const Icon(Icons.arrow_back)),
                        hintText: AppLocalizations.of(context)!
                            .search_food_or_ingredient,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 3),
                      ),
                      controller: controllersearch,
                      onTap: () {
                        setState(() {
                          searchedfield = true;
                        });
                      },
                      onChanged: (value) async {
                        if (value.length > 2) {
                          List<Ingredient>? ingListt = await ingredientRepo
                              .getIngredientsByName("ingredients", value);
                          setState(() {
                            ingList = ingListt;
                          });
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: !searchedfield,
                    child: ListTile(
                        onTap: () {
                          customEntryModal();
                        },
                        title: Text(AppLocalizations.of(context)!.custom_entry,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                        leading: const Icon(
                          Icons.add_box_outlined,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10),
                  )
                ],
              ),
              preferredSize: !searchedfield
                  ? const Size.fromHeight(120)
                  : const Size.fromHeight(30)),
          elevation: 1,
          automaticallyImplyLeading: !searchedfield,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: !searchedfield
              ? Text(widget.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700))
              : null,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: ingListSelected.isNotEmpty &&
                  searchedfield == false &&
                  controllersearch.text == ""
              ? ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context)!.overall_added +
                            ": ${ingListSelected.fold(0, (num previousValue, element) => previousValue + element.calorie!.toDouble()).round()} kcal",
                        style: const TextStyle(fontSize: 18),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade400,
                          )),
                    ),
                    ...ingListSelected.map((item) {
                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: ListTile(
                              onTap: () {
                                ingredientInfoModal(item);
                              },
                              title: Text(item.name.toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.type == "custom entry"
                                        ? AppLocalizations.of(context)!
                                            .custom_entry
                                            .toUpperCase()
                                        : item.category
                                            .toString()
                                            .toUpperCase(),
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                      "${item.servings} x ${item.servingSize}"),
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  ingListSelected.remove(item);
                                  setState(() {});
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              "${item.calorie!.round()} kcal  ",
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18)),
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                  ],
                )
              : ingList != null && controllersearch.text != ""
                  ? ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            AppLocalizations.of(context)!.search_results,
                            style: const TextStyle(fontSize: 18),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade400,
                              )),
                        ),
                        ...ingList!.map((item) {
                          return Column(
                            children: [
                              Container(
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                height: 2,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: ListTile(
                                  onTap: () {
                                    ingredientInfoModal(item);
                                  },
                                  title: Text(item.name.toString()),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.category.toString()),
                                      Text(item.servingSize.toString()),
                                    ],
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      ingListSelected.add(item);
                                      setState(() {
                                        searchedfield = false;
                                        myFocusNode.unfocus();
                                        controllersearch.text = "";
                                      });
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${item.calorie!.round()} kcal  ",
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18)),
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.add_circle_outline_outlined,
                                              size: 20,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })
                      ],
                    )
                  : controllersearch.text != ""
                      ? SingleChildScrollView(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      AppLocalizations.of(context)!
                                              .we_dit_our_best +
                                          " '${controllersearch.text}' " +
                                          AppLocalizations.of(context)!.there,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 25)),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .you_can_add_custom_food,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        searchedfield = false;
                                        myFocusNode.unfocus();
                                        controllersearch.text = "";
                                      });
                                      customEntryModal();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .add_custom_food,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(5),
                                      primary: Colors.green, // background
                                      onPrimary: Colors.white, // foreground
                                      onSurface: Colors.green,
                                      minimumSize: const Size.fromHeight(50),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
        ),
        bottomNavigationBar: ingListSelected.isNotEmpty && !searchedfield
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                color: Colors.white,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    double totalFat = ingListSelected.fold(
                        0,
                        (num previousValue, element) =>
                            previousValue + element.fat!.toDouble());
                    double totalCarb = ingListSelected.fold(
                        0,
                        (num previousValue, element) =>
                            previousValue + element.carbohydrate!.toDouble());
                    double totalCalorie = ingListSelected.fold(
                        0,
                        (num previousValue, element) =>
                            previousValue + element.calorie!.toDouble());
                    double totalProtein = ingListSelected.fold(
                        0,
                        (num previousValue, element) =>
                            previousValue + element.protein!.toDouble());
                    Map data = {
                      "meal": widget.meal,
                      "data": ingListSelected
                        ..forEach((element) {
                          element.eaten = true;
                        }),
                      "day": widget.currentDiet.day,
                      "uid": widget.currentDiet.uid,
                      "idealCalory": widget.currentDiet.dailyCalory,
                      "idealCarbohydrate": widget.currentDiet.dailyCarbs,
                      "idealFat": widget.currentDiet.dailyFat,
                      "idealProtein": widget.currentDiet.dailyProtein,
                      "fatEaten": widget.currentDiet.fatEaten == 0.0
                          ? totalFat
                          : widget.currentDiet.fatEaten -
                              (oldTotalFat - totalFat),
                      "proteinEaten": widget.currentDiet.proteinEaten == 0.0
                          ? totalProtein
                          : widget.currentDiet.proteinEaten -
                              (oldTotalprotein - totalProtein),
                      "caloryEaten": widget.currentDiet.caloryEaten == 0.0
                          ? totalCalorie
                          : widget.currentDiet.caloryEaten -
                              (oldTotalCalorie - totalCalorie),
                      "carbsEaten": widget.currentDiet.carbsEaten == 0.0
                          ? totalCarb
                          : widget.currentDiet.carbsEaten -
                              (oldTotalCarb - totalCarb),
                    };
                    var reponse = await updateDietCustom(
                        widget.currentDiet.day! + "_" + widget.currentDiet.uid!,
                        data);
                    if (reponse['status'] == "ok") {
                      widget.callback();
                      Navigator.pop(context);
                    } else {
                      showSnackBar(
                          reponse['status'], context, reponse['message']);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.done,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  showSnackBar(String status, BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor:
          status == "ok" ? Colors.green.shade100 : Colors.red.shade100,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(status == "ok" ? Icons.check : Icons.warning_amber_rounded,
                color: status == "ok" ? Colors.green : Colors.red, size: 30),
            const SizedBox(width: 20),
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    ));
  }

  Future<Map> updateDietCustom(dietId, data) async {
    var pythonServer = await ApiKey().getSettingskeys('pythonServer');
    var pythonServerAuthKey =
        await ApiKey().getSettingskeys('pythonServerAuthKey');
    var url = '${pythonServer}api/diets/custom/$dietId';
    var dio = Dio();
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 50000; //50s
    dio.options.receiveTimeout = 5000;
    try {
      var response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Basic $pythonServerAuthKey',
          },
        ),
      );
      return {
        "status": response.data['status'],
        "message": response.data['message']
      };
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {
        "status": "error",
        "message": AppLocalizations.of(context)!.error
      };
    }
  }

  customEntryModal() {
    double width = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKeyCustomEntry,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: width - 80,
                            child: Text(
                              AppLocalizations.of(context)!.custom_entry,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            width: 50,
                            child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                )),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.bottomLeft,
                        width: width,
                        child: Text(
                          "*" +
                              AppLocalizations.of(context)!
                                  .required_information,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          controller: controllerDescription,
                          decoration: InputDecoration(
                            labelText:
                                "*" + AppLocalizations.of(context)!.description,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .description_required;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerCalories,
                          decoration: InputDecoration(
                            labelText:
                                "*" + AppLocalizations.of(context)!.calories,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .calories_required;
                            } else {
                              bool numberValid =
                                  RegExp(r'^[0-9]+$').hasMatch(value.trim());
                              if (!numberValid) {
                                return AppLocalizations.of(context)!
                                    .only_numeric_characters;
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerCarbs,
                          decoration: InputDecoration(
                            labelText:
                                AppLocalizations.of(context)!.carbohydrates,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              bool numberValid =
                                  RegExp(r'^[0-9]+$').hasMatch(value.trim());
                              if (!numberValid) {
                                return AppLocalizations.of(context)!
                                    .only_numeric_characters;
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerProteins,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.protein,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              bool numberValid =
                                  RegExp(r'^[0-9]+$').hasMatch(value.trim());
                              if (!numberValid) {
                                return AppLocalizations.of(context)!
                                    .only_numeric_characters;
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerFats,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.fat,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              bool numberValid =
                                  RegExp(r'^[0-9]+$').hasMatch(value.trim());
                              if (!numberValid) {
                                return AppLocalizations.of(context)!
                                    .only_numeric_characters;
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background
                          onPrimary: Colors.white, // foreground
                          onSurface: Colors.green,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          if (_formKeyCustomEntry.currentState!.validate()) {
                            ingListSelected.add(Ingredient(
                                name: controllerDescription.text,
                                calorie: double.parse(controllerCalories.text),
                                carbohydrate:
                                    double.tryParse(controllerCarbs.text) ?? 0,
                                protein:
                                    double.tryParse(controllerProteins.text) ??
                                        0,
                                fat: double.tryParse(controllerFats.text) ?? 0,
                                servings: 1,
                                servingSize: "1 portion",
                                type: "custom entry",
                                eaten: true));
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.add,
                          style: const TextStyle(fontSize: 25),
                        ),
                      )
                    ]))))).then((value) {
      controllerDescription.text = "";
      controllerCalories.text = "";
      controllerCarbs.text = "";
      controllerProteins.text = "";
      controllerFats.text = "";
    });
  }

  ingredientInfoModal(Ingredient ingredient) {
    double width = MediaQuery.of(context).size.width;
    Ingredient ingredientEdited = Ingredient.fromJson(ingredient.toJson());
    int? pp = ingredientEdited.portions
        ?.indexWhere((element) => element.description == "100 g");
    if (pp == -1) {
      ingredientEdited.portions
          ?.add(Portion(description: '100 g', weight: 100.0));
    }
    controllerNumberServing.text = ingredientEdited.servings.toString();
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context2) {
          // ...
          return StatefulBuilder(builder: (context2, modalState) {
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKeyIngredientInfo,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: width - 80,
                            child: Text(
                              ingredientEdited.name.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: () => Navigator.pop(context2),
                                icon: const Icon(Icons.close)),
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            border: Border.all(
                              color: Colors.green.shade200,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade200,
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  )),
                              child: Text(
                                  "${ingredientEdited.calorie!.round()} kcal",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width / 3 - 12,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      border: Border.all(
                                        color: Colors.green.shade200,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${ingredientEdited.protein!.toStringAsFixed(1)} g",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          AppLocalizations.of(context)!.protein)
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 3 - 12,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      border: Border.all(
                                        color: Colors.green.shade200,
                                      )),
                                  child: Column(
                                    children: [
                                      Text(
                                          "${ingredientEdited.carbohydrate!.toStringAsFixed(1)} g",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(AppLocalizations.of(context)!
                                          .carbohydrates)
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 3 - 12,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      border: Border.all(
                                        color: Colors.green.shade200,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(
                                          "${ingredientEdited.fat!.toStringAsFixed(1)} g",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(AppLocalizations.of(context)!.fat)
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: width,
                        child: Text(
                          AppLocalizations.of(context)!.serving_size,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: width,
                        child: Text(
                          "${ingredientEdited.servings} x ${ingredientEdited.servingSize}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.grey.shade200,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controllerNumberServing,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .number_of_servings,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 3),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .number_of_serving_required;
                            } else {
                              bool numberValid =
                                  RegExp(r'^[1-9]+$').hasMatch(value.trim());
                              if (!numberValid) {
                                return AppLocalizations.of(context)!
                                    .only_numeric_characters;
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (int.tryParse(value) != null) {
                              int val = int.parse(value);
                              ingredientEdited.calorie =
                                  ingredient.calorie! * val;
                              ingredientEdited.carbohydrate =
                                  ingredient.carbohydrate! * val;
                              ingredientEdited.fat = ingredient.fat! * val;
                              ingredientEdited.protein =
                                  ingredient.protein! * val;
                              ingredientEdited.servings = val;
                            }
                          },
                        ),
                      ),
                      if (ingredientEdited.type != "custom entry")
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          color: Colors.grey.shade200,
                          child: DropdownButton(
                              value: ingredientEdited.servingSize,
                              isExpanded: true,
                              items: ingredientEdited.portions
                                  ?.map((e) => DropdownMenuItem(
                                        child: Text(e.description +
                                            " (${isInteger(e.weight) ? e.weight.round() : e.weight}g)"),
                                        value: e.description,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                double currWeight = ingredientEdited.portions!
                                    .firstWhere((element) =>
                                        element.description == value)
                                    .weight;
                                double oldWeight = ingredientEdited.portions!
                                    .firstWhere((element) =>
                                        element.description ==
                                        ingredientEdited.servingSize)
                                    .weight;
                                modalState(() {
                                  ingredientEdited.calorie =
                                      ingredientEdited.calorie! *
                                          (currWeight / oldWeight);
                                  ingredientEdited.fat = ingredientEdited.fat! *
                                      (currWeight / oldWeight);
                                  ingredientEdited.carbohydrate =
                                      ingredientEdited.carbohydrate! *
                                          (currWeight / oldWeight);
                                  ingredientEdited.protein =
                                      ingredientEdited.protein! *
                                          (currWeight / oldWeight);
                                  ingredientEdited.servingSize = value;
                                });
                              }),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background
                          onPrimary: Colors.white, // foreground
                          onSurface: Colors.green,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          if (_formKeyIngredientInfo.currentState!.validate()) {
                            setState(() {
                              int index = ingListSelected.indexWhere(
                                  (element) => element.name == ingredient.name);
                              if (index == -1 && ingList != null) {
                                index = ingList!.indexWhere((element) =>
                                    element.name == ingredient.name);
                                ingList![index] = ingredientEdited;
                              } else {
                                ingListSelected[index] = ingredientEdited;
                              }
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.save,
                          style: const TextStyle(fontSize: 25),
                        ),
                      )
                    ]),
                  )),
            );
          });
        }).then((value) {
      controllerNumberServing.text = "";
    });
  }

  bool isInteger(num value) => value is int || value == value.roundToDouble();
}
