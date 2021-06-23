import 'package:flutter/foundation.dart';

import '../models/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> Products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.Products,
      @required this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            Products: cartProducts,
            dateTime: DateTime.now()));
  }
}
