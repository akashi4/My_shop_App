import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);

  static const routeName = '/edit_product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); // key for the form in order to be saved
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '');
  var _initValue = {
    "id": '',
    "title": '',
    'description': '',
    'price': '',
  };

  bool _isInit =
      false; // to execute the code inside didchangedependencies function once

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(() => imageUpdate());
  }

  @override
  void dispose() {
    //dispose every listener and focus node, after leaving the widget
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void imageUpdate() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      _editedProduct =
          Provider.of<ProductsProvider>(context).findByID(productId);
      _initValue['title'] = _editedProduct.title;
      _initValue['id'] = _editedProduct.id;
      _initValue['description'] = _editedProduct.description;
      _initValue['price'] = _editedProduct.price.toString();
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = true;
  }

  Future<void> saveform() async {
    final isvalid = _formKey.currentState.validate();
    if (isvalid) {
      return;
    }
    _formKey.currentState.save();
    if (_editedProduct.id == null) {
      setState(() {
        _isLoading = !_isLoading;
      });
      try {
        Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('An error occured'),
                content: Text('Something went wrong'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'))
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = !_isLoading;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {}

      Navigator.of(context).pop();
    }
  }

  String imageValidator(String value) {
    if (value.isEmpty) {
      return 'please provide a valid image url';
    }

    if (!value.startsWith('http') ||
        !value.startsWith('https') ||
        !value.endsWith('jpg') ||
        !value.endsWith(' jpeg') ||
        !value.endsWith('png')) {
      return 'please provide a valid image url';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: saveform)],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please type something in the title area';
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl)),
                    TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            isFavorite: _editedProduct.isFavorite,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl)),
                    TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter a valid description';
                          }
                          if (value.length >= 10) {
                            return 'please do not enter a description greater than 10 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value,
                            isFavorite: _editedProduct.isFavorite,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8.0, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('fill the image url first')
                                : FittedBox(
                                    child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ))),
                        Expanded(
                          child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Image Url",
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                saveform();
                              },
                              validator: (value) {
                                return imageValidator(value);
                              },
                              onSaved: (value) => _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  isFavorite: _editedProduct.isFavorite,
                                  imageUrl: value)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
