import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/order_item.dart';
import 'package:tasks_app/providers/orders_provider.dart';
import 'package:tasks_app/widgets/app_drawer.dart';
import 'package:tasks_app/widgets/order_list_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    print('Building orders...');
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your orders '),
      ),
      body: FutureBuilder(
          future: Provider.of<OrdersProvider>(context, listen: false)
              .fetchAndSetOrder(),
          builder: (ctx,snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<OrdersProvider>(builder: (ctx,orderData,child) => ListView.builder(
            itemCount: orderData.orders.length,
            itemBuilder: (ctx, i) => OrderListItem(orderData.orders[i]),
          ));
        }
      })
    );
  }
}
