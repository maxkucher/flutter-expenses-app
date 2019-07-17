import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/products_provider.dart';
import 'package:tasks_app/screens/edit_product_screen.dart';

class UserProductListItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductListItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName,
                arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context,
                builder: (ctx)  => AlertDialog(
                  title: Text('Deletion confirmation'),
                  content: Text('Do you want to dlete this product?'),
                  actions: <Widget>[
                    FlatButton(onPressed: () async {
                      await Provider.of<ProductsProvider>(context,listen: false)
                          .deleteProduct(id);
                      Navigator.of(context)
                          .pop();

                    },
                        child: Text('Yes')),
                    FlatButton(onPressed: (){
                      Navigator.of(context)
                          .pop();
                    },
                        child: Text('No'))
                  ],
                ));
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
