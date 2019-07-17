import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/cart.dart';
import 'package:tasks_app/providers/products_provider.dart';
import 'package:tasks_app/widgets/app_drawer.dart';
import 'package:tasks_app/widgets/badge.dart';
import 'package:tasks_app/widgets/products_grid.dart';

import 'cart_screen.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavs = false;
  var _isInit = false;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (!_isInit) {
      try{
        await Provider.of<ProductsProvider>(context).fetchProducts();
      }catch (e){
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                switch (selectedValue) {
                  case FilterOptions.Favourites:
                    _showOnlyFavs = true;
                    break;
                  case FilterOptions.All:
                    _showOnlyFavs = false;
                    break;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () =>
                    {Navigator.of(context).pushNamed(CartScreen.routeName)},
                icon: Icon(Icons.shopping_cart)),
            builder: (_, cartdata, child) =>
                Badge(value: cartdata.itemCount.toString(), child: child),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavs),
    );
  }
}
