import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitfood/models/faliure.dart';
import 'package:fitfood/models/search_results.dart';
import 'package:fitfood/repo/get_search_results.dart';
import 'package:flutter/foundation.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final repo = SearchRepo();
  SearchResultsBloc() : super(SearchResultsInitial()) {
    on<SearchResultsEvent>((event, emit) async {
      if (event is LoadSearchResults) {
        try {
          emit(SearchResultsLoading());
          final results = await repo.getSearchList(event.name, 100);
          emit(SearchResultsSuccess(
            results: results.list,
          ));
        } on Failure catch (e) {
          emit(HomeFailureState(error: e));
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          emit(SearchResultsError());
        }
      }
    });
  }
}
