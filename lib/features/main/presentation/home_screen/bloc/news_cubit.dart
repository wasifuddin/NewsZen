import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:news_zen/config/server_config.dart';
import 'package:news_zen/core/model/news_model.dart';
import 'package:news_zen/core/data/remote/mock_data.dart';
import 'news_state.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';



class NewsCubit extends Cubit<NewsState> {
  int currentPage = 1;
  final int limit = 10;
  bool hasMoreData = true;

  List<NewsModel> pageViewNews=[];
  List<NewsModel> horizontalNews=[];
  NewsCubit() : super(NewsInitial()){
    loadNews(currentPage: currentPage);
  }



  Future<void> loadNews({required int currentPage}) async {
    try {
      emit(NewsLoading());

      final urldata= datafetchurl + "?page=$currentPage";
      final response = await http.get(Uri.parse(urldata)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the response body
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          hasMoreData = false;
        }
        else
        {
          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();
          if(currentPage==1) pageViewNews.addAll(news);
          horizontalNews.addAll(news);
          //currentPage++;
        }

        emit(NewsLoaded(
          pageViewNews: pageViewNews,
          horizontalNews: horizontalNews,
        ));
      } else {
        emit(NewsError(error: 'Failed to load news'));
      }
    } catch (e) {
      emit(NewsError(error: e.toString()));
    }
  }

  List<NewsModel> filterPageViewNews(String topic) {
    final filteredNews = topic == 'All'
        ? pageViewNews
        : pageViewNews.where((news) => news.topic == topic).toList();
    if(topic=='All')
    {
      emit(NewsLoaded(
        pageViewNews: filteredNews,
        horizontalNews: (state as NewsLoaded).horizontalNews,
      ));
      return pageViewNews;
    }
    emit(NewsLoaded(
      pageViewNews: filteredNews,
      horizontalNews: (state as NewsLoaded).horizontalNews,
    ));
    return pageViewNews.where((news) => news.topic == topic).toList();;
  }

  List<NewsModel> filterHorizontalNews(String topic) {
    final filteredNews = topic == 'All'
        ? horizontalNews
        : horizontalNews.where((news) => news.topic == topic).toList();
    if (topic == 'All') {
      emit(NewsLoaded(
        pageViewNews: (state as NewsLoaded).pageViewNews,
        horizontalNews: horizontalNews,
      ));
      return horizontalNews;
    }
    emit(NewsLoaded(
      pageViewNews: (state as NewsLoaded).pageViewNews,
      horizontalNews: filteredNews,
    ));
    return horizontalNews.where((news) => news.topic == topic).toList();
    // return filteredNews;
  }
}


