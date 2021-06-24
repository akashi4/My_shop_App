import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://myshop-9d36f-default-rtdb.firebaseio.com/orders.json');
    final timeSpan = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": timeSpan.toIso8601String(),
          "products": cartProducts.map((cartProd) {
            return {
              "id": cartProd.id,
              "title": cartProd.title,
              "quantity": cartProd.quantity,
              "price": cartProd.price
            };
          }).toList()
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            Products: cartProducts,
            dateTime: timeSpan));
  }

  Future<void> FetchAndSetOrders() async {
    final url = Uri.parse(
        'https://myshop-9d36f-default-rtdb.firebaseio.com/orders.json');

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'],
          Products: (orderData['product'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity']);
          }).toList()));
    });

    _orders = loadedOrders;
    notifyListeners();
  }
}
