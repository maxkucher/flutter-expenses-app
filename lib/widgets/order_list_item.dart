import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/providers/order_item.dart';

class OrderListItem extends StatelessWidget {
  final OrderItem orderItem;

  OrderListItem(this.orderItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${orderItem.amount}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(orderItem.date)),
            trailing:
                IconButton(icon: Icon(Icons.expand_more), onPressed: () {}),
          )
        ],
      ),
    );
  }
}
