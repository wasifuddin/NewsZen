part of "explore_bloc.dart";

abstract class ExploreState {}

class ExploreLoadingState extends ExploreState {}

class ExploreLoadedState extends ExploreState {
  final List<NewsModel> news;
  final String selectedTopic;

  ExploreLoadedState(this.news, this.selectedTopic);
}