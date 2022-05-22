import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutter/src/models/category_model.dart';
import 'package:news_flutter/src/models/news_model.dart';
import 'package:flutter/material.dart';

final _URL_NEWS = "https://newsapi.org/v2";
final _APIKEY = "648c2f1febcb4a4986611bdc0c7a5a08";

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = "business";

  List<Category> categories = [
    Category(FontAwesomeIcons.building, "business"),
    Category(FontAwesomeIcons.tv, "entertainment"),
    Category(FontAwesomeIcons.addressCard, "general"),
    Category(FontAwesomeIcons.headSideVirus, "health"),
    Category(FontAwesomeIcons.vials, "science"),
    Category(FontAwesomeIcons.volleyball, "sports"),
    Category(FontAwesomeIcons.memory, "technology"),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = [];
    });
    this.getArticlesByCategory(this._selectedCategory);
  }

  String get selectedCategory => this._selectedCategory;

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory] as List<Article>;

  set selectedCategory(String valor) {
    this._selectedCategory = valor;

    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  getTopHeadlines() async {
    final url =
        Uri.parse("$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co");
    final response = await http.get(url);

    final newsResponse = newsResponseFromJson(response.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category]!.length > 0) {
      return this.categoryArticles[category];
    }

    final url = Uri.parse(
        "$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co&category=$category");
    final response = await http.get(url);

    final newsResponse = newsResponseFromJson(response.body);
    this.categoryArticles[category]!.addAll(newsResponse.articles);
    notifyListeners();
  }
}
