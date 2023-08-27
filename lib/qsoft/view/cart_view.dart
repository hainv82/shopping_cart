import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/qsoft/bloc/qsoft_bloc.dart';
import 'package:shopping_cart/qsoft/model/items_cart.model.dart';
import 'package:shopping_cart/qsoft/view/item_cart_view.dart';
import 'package:shopping_cart/sql_helper2.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Map<String, dynamic>> _allItems = [];
  List<ItemCart> listItem = [];
  bool _isLoading = true;
  int totalItem = 0;
  int totalPrice = 0;

  void _refreshCarts() async {
    final data = await SQLHelper2.getCarts();
    setState(() {
      _allItems = data;
      totalItem = 0;
      totalPrice = 0;
      List<ItemCart> _listRefresh = [];
      if (data.isNotEmpty) {
        for (int i = 0; i < data.length; i++) {
          // _listRefresh.add(ItemCart(price, id: id, sku: sku, name: name, thumb: thumb, quantity: quantity));

          _listRefresh.add(ItemCart(
              id: data[i]['id'],
              sku: data[i]['sku'],
              name: data[i]['name'],
              thumb: data[i]['thumb'],
              price: data[i]['price'],
              quantity: data[i]['quantity']));

          totalItem = totalItem + int.parse(data[i]['quantity'].toString());
          totalPrice = totalPrice +
              int.parse(data[i]['price'].toString()) *
                  int.parse(data[i]['quantity'].toString());
        }
      }
      listItem = _listRefresh;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCarts();
  }

// Insert a new item to the database
  Future<void> _addItem(
      {required String sku,
      required String name,
      required String thumb,
      required String price,
      required int quantity}) async {
    await SQLHelper2.createItem(
        sku: sku, name: name, thumb: thumb, quantity: quantity, price: price);
    _refreshCarts();
  }

  // Update an existing item
  Future<void> _updateItem({
    required int id,
    required String sku,
    required String name,
    required String thumb,
    required String price,
    required int quantity,
  }) async {
    await SQLHelper2.updateItem(
        id: id,
        sku: sku,
        name: name,
        thumb: thumb,
        quantity: quantity,
        price: price);
    _refreshCarts();
  }

  // Delete an item
  void _deleteItem({required int id}) async {
    await SQLHelper2.deleteItem(id: id);
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Successfully deleted a items!'),
    // ));
    _refreshCarts();
  }

  void _dropTable() async {
    await SQLHelper2.dropData();
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Successfully drop'),
    // ));
    _refreshCarts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart($totalItem)',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 130.0),
            child: ListView.builder(
              itemCount: listItem.length,
              itemBuilder: (context, index) => ItemCartView(
                data: listItem[index],
                onPlus: (item) {
                  _updateItem(
                      id: item.id,
                      sku: item.sku,
                      name: item.name,
                      thumb: item.thumb,
                      price: item.price,
                      quantity: item.quantity + 1);
                },
                onMinus: (item) {
                  _updateItem(
                      id: item.id,
                      sku: item.sku,
                      name: item.name,
                      thumb: item.thumb,
                      price: item.price,
                      quantity: item.quantity - 1);
                },
                onDelete: (id) {
                  _deleteItem(id: int.parse(id));
                },
                onQuantityChanged: (int quantity, bool fromButton) {
                  _updateItem(
                      id: listItem[index].id,
                      sku: listItem[index].sku,
                      name: listItem[index].name,
                      thumb: listItem[index].thumb,
                      price: listItem[index].price,
                      quantity: quantity);
                  context.read<QSoftBloc>().add(DoneUpdateItemCartEvent());
                  _refreshCarts();
                },
                callBackUpdateQuantity: (item, quantity) {
                  _updateItem(
                      id: item.id,
                      sku: item.sku,
                      name: item.name,
                      thumb: item.thumb,
                      price: item.price,
                      quantity: int.parse(quantity));
                  context.read<QSoftBloc>().add(DoneUpdateItemCartEvent());
                },
              ),
            ),
          ),

          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              height: 130,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(2, 1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total price',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text.rich(
                          TextSpan(
                            text: NumberFormat("#,##0", "en_US")
                                .format(totalPrice),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: ' đ',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16)),
                              // can add more TextSpans here...
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _dropTable();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Center(
                                  child: Text(
                                'Order Successfully',
                                style: TextStyle(fontSize: 24),
                              )),
                              actions: <Widget>[
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.pop(context);
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: Colors.orange,
                                      ),
                                      child: const Text(
                                        'Back to Home',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                        color: Colors.orangeAccent,
                      ),
                      width: MediaQuery.of(context).size.width - 40,
                      child: const Text(
                        'Order',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Align(
          //   alignment: FractionalOffset.bottomCenter,
          //   child: Container(
          //     color: Colors.blueGrey,
          //     height: 200,
          //     child: ,
          //   ),
          // ),
        ],
      ),
    );
  }
}
