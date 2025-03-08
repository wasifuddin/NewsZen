import 'package:equatable/equatable.dart';
import 'package:news_zen/core/model/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> pageViewNews;
  final List<NewsModel> horizontalNews;

  const NewsLoaded({
    required this.pageViewNews,
    required this.horizontalNews,
  });

  @override
  List<Object?> get props => [pageViewNews, horizontalNews];
}

class NewsError extends NewsState {
  final String error;

  const NewsError({required this.error});

  @override
  List<Object?> get props => [error];
}
