// features/explore/bloc/explore_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'package:news_zen/core/model/news_model.dart';

part 'explore_state.dart';
part 'explore_event.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreLoadingState()) {
    on<ChangeTopicEvent>(_onChangeTopic);
    on<LoadExploreDataEvent>(_onLoadExploreData);
    on<SelectTagEvent>(_onSelectTag);
  }

  void _onChangeTopic(ChangeTopicEvent event, Emitter<ExploreState> emit) {
    final filteredNews = event.topic == 'All'
        ? mockNewsData
        : mockNewsData.where((news) => news.topic == event.topic).toList();
    emit(ExploreLoadedState(filteredNews, event.topic));
  }

  void _onLoadExploreData(LoadExploreDataEvent event, Emitter<ExploreState> emit) {
    emit(ExploreLoadedState(mockNewsData, 'All'));
  }

  void _onSelectTag(SelectTagEvent event, Emitter<ExploreState> emit) {
    if (state is ExploreLoadedState) {
      final currentState = state as ExploreLoadedState;
      final filteredNews = mockNewsData
          .where((news) =>
      news.title.toLowerCase().contains(event.tag.toLowerCase()) ||
          news.description.toLowerCase().contains(event.tag.toLowerCase()))
          .toList();
      emit(ExploreLoadedState(filteredNews, currentState.selectedTopic));
    }
  }
}