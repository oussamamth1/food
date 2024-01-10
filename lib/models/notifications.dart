import 'dart:convert';

class Notifications {
  String? uid;
  MealTime? mealTime;
  bool? water;

  Notifications({this.uid, this.water = false, this.mealTime});

  factory Notifications.fromJson(jsons) => Notifications(
        uid: jsons['uid'],
        mealTime: MealTime.fromJson(json.decode(jsons['mealTime'])),
        water: jsons['water'],
      );

  @override
  String toString() {
    return "uid: $uid mealTime: ${mealTime.toString()} water: $water |";
  }
}

class MealTime {
  bool? breakfast;
  String? breakfastTime;
  bool? lunch;
  String? lunchTime;
  bool? secondSnack;
  String? secondSnackTime;
  bool? firstSnack;
  String? firstSnackTime;
  bool? dinner;
  String? dinnerTime;

  MealTime({
    this.breakfast = false,
    this.breakfastTime = "07:00",
    this.lunch = false,
    this.lunchTime = "12:30",
    this.firstSnack = false,
    this.firstSnackTime = "10:00",
    this.secondSnack = false,
    this.secondSnackTime = "14:00",
    this.dinner = false,
    this.dinnerTime = "19:00",
  });

  factory MealTime.fromJson(json) => MealTime(
        breakfast: json['breakfast'],
        breakfastTime: json['breakfastTime'],
        lunch: json['lunch'],
        lunchTime: json['lunchTime'],
        firstSnack: json['firstSnack'],
        firstSnackTime: json['firstSnackTime'],
        secondSnack: json['secondSnack'],
        secondSnackTime: json['secondSnackTime'],
        dinner: json['dinner'],
        dinnerTime: json['dinnerTime'],
      );

  toJson() => {
    'breakfast': breakfast,
    'breakfastTime': breakfastTime,
    'lunch': lunch,
    'lunchTime': lunchTime,
    'firstSnack': firstSnack,
    'firstSnackTime': firstSnackTime,
    'secondSnack': secondSnack,
    'secondSnackTime': secondSnackTime,
    'dinner': dinner,
    'dinnerTime': dinnerTime,
  };

  @override
  String toString() {
    return "breakfast: $breakfast breakfastTime: $breakfastTime lunch: $lunch lunchTime: $lunchTime dinner: $dinner |";
  }
}
