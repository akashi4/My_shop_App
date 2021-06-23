import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/edit_product_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product.dart';
import '../widgets/App_drawer.dart';

class UserProductScreen extends StatelessWidget {
  // this class is about all the item created by the user, they can be edited and deleted here
  static const routeName = '/userProduct';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, i) => Column(
                    children: [
                      UserProduct(
                          id: productData.items[i].id,
                          title: productData.items[i].title,
                          imageUrl: productData.items[i].imageUrl),
                      Divider()
                    ],
                  )),
        ),
      ),
    );
  }
}
