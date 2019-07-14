import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/products_provider.dart';
import 'package:tasks_app/screens/edit_product_screen.dart';
import 'package:tasks_app/widgets/app_drawer.dart';
import 'package:tasks_app/widgets/user_product_list_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        })],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: <Widget>[
                UserProductListItem(
                      id: productsData.items[i].id,
                      title: productsData.items[i].title,
                      imageUrl: productsData.items[i].imageUrl,
                    ),
                Divider()
              ],
            )),
      ),
    );
  }
}
