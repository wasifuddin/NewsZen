// features/search/bloc/search_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    try {
      final results = mockNewsData
          .where((news) =>
      news.title.toLowerCase().contains(event.query.toLowerCase()) ||
          news.description.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError('Failed to load search results'));
    }
  }
}