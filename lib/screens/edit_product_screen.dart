import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/product.dart';
import 'package:tasks_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    if (_form.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _form.currentState.save();
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);

      try {
        if (_editedProduct.id != null) {
          await productsProvider.updateProduct(_editedProduct);
        } else {
          await productsProvider.addProduct(_editedProduct);
        }
        Navigator.of(context)
        .pop();
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error ocurred'),
                  content: Text('Failed to save the product'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(''))
                  ],
                ));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
        title: Text('Edit Product'),
      ),
      body: !_isLoading
          ? Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _editedProduct.title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        onSaved: (val) => {
                          _editedProduct = new Product(
                              id: _editedProduct.id,
                              title: val,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl)
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please endter  the price';
                          }
                          var enteredPrice = double.tryParse(val);
                          if (enteredPrice == null) {
                            return 'Please enter a valid number';
                          }
                          if (enteredPrice <= 0) {
                            return 'The price should be greater than 0';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (val) => {
                          _editedProduct = new Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(val),
                              imageUrl: _editedProduct.imageUrl)
                        },
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter description';
                          }
                          if (value.length < 10) {
                            return 'Description length hould be greater than 10';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 4,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (val) => {
                          _editedProduct = new Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: val,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl)
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter the URL')
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                      fit: BoxFit.cover,
                                    )),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the image url message';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter valid URL';
                                }
                                return null;
                              },
                              focusNode: _imageUrlFocusNode,
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (val) => {
                                _editedProduct = new Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: val)
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );

    @override
    void dispose() {
      _imageUrlFocusNode.removeListener(_updateImageUrl);
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      _imageUrlController.dispose();
      _imageUrlFocusNode.dispose();
      super.dispose();
    }
  }
}
