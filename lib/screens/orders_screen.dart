import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/order_item.dart';
import 'package:tasks_app/providers/orders_provider.dart';
import 'package:tasks_app/widgets/app_drawer.dart';
import 'package:tasks_app/widgets/order_list_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your orders '),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, i) => OrderListItem(ordersProvider.orders[i]),
      ),
    );
  }
}
