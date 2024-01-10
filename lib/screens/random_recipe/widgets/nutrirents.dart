import 'package:flutter/material.dart';
import '../../../models/nutrients.dart';
import 'expandable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NutrientsWidgets extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsWidgets({Key? key, required this.nutrient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ExpandableGroup(
          isExpanded: false,
          collapsedIcon: const Icon(Icons.arrow_drop_down),
          header: Text(
            "  "+AppLocalizations.of(context)!.nutritions,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          items: [
            ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fireplace,
                    size: 35,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.calories,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  nutrient.calories,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                )),
            ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.face_outlined,
                    size: 35,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.fat,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  nutrient.fat,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                )),
            ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bakery_dining,
                    size: 35,
                    color: Colors.orange,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.carbohydrates,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  nutrient.carbs,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                )),
            ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt_outlined,
                  size: 35,
                  color: Colors.orange,
                ),
              ),
              title: Text(
                AppLocalizations.of(context)!.protein,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                nutrient.protein,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NutrientsbadWidget extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsbadWidget({Key? key, required this.nutrient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ExpandableGroup(
          isExpanded: false,
          collapsedIcon: const Icon(Icons.arrow_drop_down),
          header: Text(
            "  "+AppLocalizations.of(context)!.bad_for_health_Nutrients,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          items: [
            ...nutrient.bad.map((nutri) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                subtitle: Text("${nutri.percentOfDailyNeeds}% "+AppLocalizations.of(context)!.of_Daily_needs),
                title: Text(
                  nutri.name.toString(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  nutri.amount,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}

class NutrientsgoodWidget extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsgoodWidget({Key? key, required this.nutrient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: ExpandableGroup(
          isExpanded: false,
          collapsedIcon: const Icon(Icons.arrow_drop_down),
          header: Text(
            "  "+AppLocalizations.of(context)!.good_for_health_Nutrients,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          items: [
            ...nutrient.good.map((nutri) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                subtitle: Text("${nutri.percentOfDailyNeeds}% "+AppLocalizations.of(context)!.of_Daily_needs),
                title: Text(
                  nutri.name.toString(),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  nutri.amount,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
