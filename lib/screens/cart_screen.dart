import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/models/cart_item.dart';
import 'package:tasks_app/providers/cart.dart';
import 'package:tasks_app/providers/orders_provider.dart';
import 'package:tasks_app/widgets/cart_list_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Spacer(),
                    new OrderButton(cart: cart)
                  ],
                )),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, i) {
              CartItem cartItem = cart.items.values.toList()[i];
              String productId = cart.items.keys.toList()[i];
              return CartListItem(
                  productId: productId,
                  id: cartItem.id,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  title: cartItem.title);
            },
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {


  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading  = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: ( widget.cart.totalAmount <= 0 || _isLoading)? null :  () async {
        setState(() {
          _isLoading = true;
        });

        await Provider.of<OrdersProvider>(context, listen: false)
        .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);

        setState(() {
          _isLoading = false;
        });

        widget.cart.clearCart();
      },
      child: Text('Order now'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
