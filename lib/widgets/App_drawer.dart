import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/orders_screen.dart';
import '../pages/user_product.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Hello Friends'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
