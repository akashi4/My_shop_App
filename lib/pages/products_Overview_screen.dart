import 'package:MyShop_App/widgets/App_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../models/cart.dart';
import '../pages/cart_screens.dart';

// enum are mostly used to replace integer, simple and unique var
enum FiltersOption {
  All,
  Favorites,
}

class ProducOverviewScreen extends StatefulWidget {
  @override
  _ProducOverviewScreenState createState() => _ProducOverviewScreenState();
}

class _ProducOverviewScreenState extends State<ProducOverviewScreen> {
  var showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).accentIconTheme.color,
              ),
              //onPressed: () {},
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOption.All,
              ),
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FiltersOption.Favorites,
              ),
            ],
            onSelected: (FiltersOption selectedValue) {
              setState(() {
                if (selectedValue == FiltersOption.All) {
                  showOnlyFavorites = false;
                } else {
                  showOnlyFavorites = true;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.items.length.toString(),
            ),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(showOnlyFavorites),
    );
  }
}
