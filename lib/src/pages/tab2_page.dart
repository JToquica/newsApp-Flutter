import 'package:flutter/material.dart';
import 'package:news_flutter/src/models/category_model.dart';
import 'package:news_flutter/src/services/news_service.dart';
import 'package:news_flutter/src/theme/tema.dart';
import 'package:news_flutter/src/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';

class Tab2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articlesBySelectedCategory =
        Provider.of<NewsService>(context).getArticulosCategoriaSeleccionada;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _ListaCategorias(),
            Expanded(
              child: (articlesBySelectedCategory.length == 0)
                  ? Center(
                      child: CircularProgressIndicator(
                        color: miTema.colorScheme.secondary,
                      ),
                    )
                  : ListaNoticias(articlesBySelectedCategory),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;

    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final cName = categories[index].name;

          return Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                _CategoryButton(categories[index]),
                SizedBox(height: 5),
                Text("${cName[0].toUpperCase()}${cName.substring(1)}"),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category category;

  const _CategoryButton(this.category);

  @override
  Widget build(BuildContext context) {
    final selectedCategory = Provider.of<NewsService>(context).selectedCategory;

    return GestureDetector(
      onTap: () {
        final newsServices = Provider.of<NewsService>(context, listen: false);
        newsServices.selectedCategory = category.name;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          category.icon,
          color: (selectedCategory == category.name)
              ? miTema.colorScheme.secondary
              : Colors.black54,
        ),
      ),
    );
  }
}
