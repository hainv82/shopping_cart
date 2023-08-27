import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/qsoft/bloc/qsoft_bloc.dart';
import 'package:shopping_cart/qsoft/model/product.model.dart';
import 'package:shopping_cart/qsoft/view/bottom_sheet_add_to_cart.dart';

class ItemHot extends StatefulWidget {
  final Product product;
  final double width, height;
  final bool isHot;

  const ItemHot(
      {Key? key,
      required this.product,
      required this.width,
      required this.height,
      required this.isHot})
      : super(key: key);

  @override
  State<ItemHot> createState() => _ItemHotState();
}

class _ItemHotState extends State<ItemHot> {
  @override
  Widget build(BuildContext context) {
    final oCcy = NumberFormat("#,##0", "en_US");
    String price = oCcy.format(int.parse(widget.product.price ?? '0'));

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey,
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(1, 1),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  widget.product.thumb ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              (widget.isHot)
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          // Image.network(
          //   product.img ?? '',
          //   fit: BoxFit.cover,
          //
          // ),
          const SizedBox(
            height: 5,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  child:
                      // Text('data')
                      Column(
                    children: [
                      Text(widget.product.name ?? ''),
                      Text.rich(
                        TextSpan(
                          text: oCcy
                              .format(int.parse(widget.product.price ?? '0')),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.deepOrange),
                          children: const <TextSpan>[
                            TextSpan(
                                text: ' đ',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                            // can add more TextSpans here...
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: GestureDetector(
                    onTap: () {
                      context.read<QSoftBloc>().add(CreateBottomSheetEvent());

                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return BottomSheetAddToCart(
                            onQuantityChanged:
                                (int quantity, bool fromButton) {},
                            initialQuantity: 1,
                            product: widget.product,
                            isFirst: 1,
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
