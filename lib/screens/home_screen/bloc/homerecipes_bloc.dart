import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fitfood/models/faliure.dart';
import 'package:fitfood/models/food_type.dart';
import 'package:fitfood/repo/get_homepage_recipe.dart';

part 'homerecipes_event.dart';
part 'homerecipes_state.dart';

class HomeRecipesBloc extends Bloc<HomeRecipesEvent, HomeRecipesState> {
  final repo = GetHomeRecipes();
  HomeRecipesBloc() : super(HomeRecipesInitial()) {
    on<HomeRecipesEvent>((event, emit) async {
      if (event is LoadHomeRecipe) {
        try {
          emit(HomeRecipesLoading());
          final data = await Future.wait([
            repo.getRecipes('breakfast', 20),
            repo.getRecipes('lunch', 3),
            repo.getRecipes('drinks', 20),
            repo.getRecipes('pizza', 3),
            repo.getRecipes('burgers', 20),
            repo.getRecipes('cake', 20),
            repo.getRecipes('rice', 20),
          ]);
          emit(
            HomeRecipesSuccess(
              breakfast: data[0].list,
              lunch: data[1].list,
              rice: data[6].list,
              drinks: data[2].list,
              burgers: data[4].list,
              pizza: data[3].list,
              cake: data[5].list,
            ),
          );
        } on Failure catch (e) {
          emit(HomeFailureState(error: e));
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          emit(HomeRecipesError());
        }
      }
    });
  }
}
