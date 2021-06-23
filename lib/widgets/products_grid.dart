import 'package:MyShop_App/models/product.dart';
import 'package:MyShop_App/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ProductItem.dart';

class ProductGrid extends StatelessWidget {
  bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final product = showFavs ? productData.favoritesItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: product[i],
          child: ProductItem(
              /* product[i].id, product[i].title, product[i].imageUrl */)),
      itemCount: product.length,
    );
  }
}
