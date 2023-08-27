import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_cart/qsoft/bloc/qsoft_bloc.dart';
import 'package:shopping_cart/qsoft/model/items_cart.model.dart';
import 'package:shopping_cart/qsoft/view/cart_view.dart';
import 'package:shopping_cart/qsoft/view/item_hot.dart';
import 'package:shopping_cart/sql_helper2.dart';

class MainQSOFT extends StatelessWidget {
  const MainQSOFT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<QSoftBloc>(
        create: (context) {
          const initialState = QSoftInitial();
          return QSoftBloc(initialState);
        },
        child: const MaterialApp(
          home: HomeContent(),
        ),
      );
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> _allItems = [];
  List<ItemCart> listItem = [];
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
    });
  }

  void _refreshTotalItem() async {
    final data = await SQLHelper2.getCarts();
    var totalCount = 0;
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        totalCount = totalCount + int.parse(data[i]['quantity'].toString());
      }
      totalItem = totalCount;
      // context.read<QSoftBloc>().add(DoneRefreshTotalItemCartEvent());
    }
    context.read<QSoftBloc>().add(UpdateTotalCartEvent(total: totalCount));
  }

  @override
  void initState() {
    super.initState();
    _refreshCarts();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    final double itemHeight = size.height / 3;
    return BlocBuilder<QSoftBloc, QSoftState>(
      buildWhen: (previous, current) =>
          previous != current && current is ProductState,
      builder: (mContext, state) {
        if (state is ProductState) {
          var data = state.listProduct;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'HOME',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orangeAccent,
              centerTitle: true,
              actions: <Widget>[
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartView()),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Stack(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1, left: 1),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<QSoftBloc, QSoftState>(
                            buildWhen: (previous, current) =>
                                previous != current &&
                                current is AddToCartState,
                            builder: (context, state) {
                              if (state is AddToCartState) {
                                _refreshTotalItem();
                              }
                              return BlocBuilder<QSoftBloc, QSoftState>(
                                buildWhen: (previous, current) =>
                                    previous != current &&
                                    current is UpdateTotalCartState,
                                builder: (context, state) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 3, left: 3),
                                    child: Text(
                                      state is UpdateTotalCartState
                                          ? state.total.toString()
                                          : totalItem.toString(),
                                      // totalItem.toString(),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'HOT Products',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      height: size.width * 1.5 / 3,
                      child: ListView(
                        // This next line does the trick.
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: state.listProduct
                            // .map((e) => Container(width: 50, height: 50,color: Colors.red,))
                            .map((e) => Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: ItemHot(
                                    product: e,
                                    height: 200,
                                    // height: size.height / 5,
                                    width: size.width / 3, isHot: true,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ALL Products',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Expanded(
                      // height: size.height*2/3,
                      child: GridView.builder(
                        itemCount: data.length,
                        primary: true,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // childAspectRatio: (itemHeight/itemWidth),
                          childAspectRatio: (itemWidth / (itemWidth * 1.3)),
                          // crossAxisSpacing: 4.0,
                          // mainAxisSpacing: 4.0
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              // color: Colors.red,
                              padding: const EdgeInsets.all(10),
                              child: ItemHot(
                                product: data[index],
                                height: size.width / 2,
                                width: size.width / 2,
                                isHot: false,
                              ));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          mContext.read<QSoftBloc>().add(GetProductEvent());
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '${DateTime.now().year}, QSoft. All rights reserved.',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      )),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
