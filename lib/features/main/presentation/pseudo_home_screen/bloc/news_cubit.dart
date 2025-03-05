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
  int currentPage = 5;
  final int limit = 10;
  bool hasMoreData = true;

  List<NewsModel> pageViewNews=[];
  List<NewsModel> horizontalNews=[];
  NewsCubit() : super(NewsInitial()){

    loadNews(currentPage: currentPage);
  }



  Future<void> loadNews({required int currentPage}) async {

    int page=1,limit=10;
    try {
      emit(NewsLoading());

      final urldata= datafetchurl + "?page=$currentPage";

      /*HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.getUrl(Uri.parse(datafetchurl));
      HttpClientResponse responsenew = await request.close();
      print("Response status: ${responsenew.statusCode}");*/

      // Send GET request to fetch news data from the backend
      final response = await http.get(Uri.parse(datafetchurl)).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the response body
        print('rihila');
        List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {

          hasMoreData = false;
        }
        else
        {
          print('rihila');
          print(data[0]);
          List<NewsModel> news = data.map((item) => NewsModel.fromJson(item)).toList();
          print('rihila');
         pageViewNews.addAll(news);
          horizontalNews.addAll(news);
          print('rihilaend');
          currentPage++;

        }



        // Map the data to NewsModel (you may need to adjust based on the structure)


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


  void filterPageViewNews(String topic) {
    final filteredNews = topic == 'All'
        ? pageViewNews
        : pageViewNews.where((news) => news.topic == topic).toList();
    emit(NewsLoaded(
      pageViewNews: filteredNews,
      horizontalNews: (state as NewsLoaded).horizontalNews,
    ));
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
    return horizontalNews.where((news) => news.topic == topic).toList();;

    // return filteredNews;
  }
}