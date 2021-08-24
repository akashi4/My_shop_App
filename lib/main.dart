import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/orders_screen.dart';
import './pages/user_product.dart';
import './pages/cart_screens.dart';
import './pages/products_Overview_screen.dart';
import './pages/orders_screen.dart';
import './pages/product_detail_screen.dart';
import './providers/products_provider.dart';
import './pages/edit_product_screen.dart';
import './pages/auth-screen.dart';
import './providers/order.dart';
import './providers/auth.dart';
import './models/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (ctx) => ProductsProvider(null, null, []),
            update: (context, auth, previousProductProvider) =>
                ProductsProvider(
                    auth.token,
                    auth.userId,
                    previousProductProvider == null
                        ? []
                        : previousProductProvider.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order([], null),
            update: (ctx, auth, previousOrder) => Order(
                previousOrder == null ? [] : previousOrder.orders, auth.token),
          ),
          ChangeNotifierProvider(create: (ctx) => Auth())
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth ? ProducOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ProducOverviewScreen.routeName: (ctx) => ProductDetailScreen(),
            },
          ),
        ));
  }
}
