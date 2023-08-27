import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/qsoft/bloc/qsoft_bloc.dart';
import 'package:shopping_cart/qsoft/model/product.model.dart';
import 'package:shopping_cart/qsoft/view/input_formatter.dart';
import 'package:shopping_cart/qsoft/view/product_quantity_input.dart';
import 'package:shopping_cart/sql_helper2.dart';

class BottomSheetAddToCart extends StatefulWidget {
  const BottomSheetAddToCart({
    Key? key,
    required this.onQuantityChanged,
    required this.initialQuantity,
    required this.product,
    required this.isFirst,
  }) : super(key: key);
  final Function(int quantity, bool fromButton) onQuantityChanged;
  final int initialQuantity;
  final Product product;
  final int isFirst;

  @override
  State<BottomSheetAddToCart> createState() => _BottomSheetAddToCartState();
}

class _BottomSheetAddToCartState extends State<BottomSheetAddToCart> {
  late TextEditingController _textFieldControllerBottomSheet;

  late TextEditingController _textFieldControllerDialog;

  Future<void> _displayTextInputDialog(BuildContext context, String quantity,
      Function(VoidCallback, String)? callBack) async {
    _textFieldControllerDialog = TextEditingController(text: quantity);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.product.name ?? ''),
            content: TextFormField(
              enabled: true,
              validator: (value) => int.tryParse(value ?? '1') == null
                  ? 'Số lượng không hợp lệ'
                  : null,
              controller: _textFieldControllerDialog,
              inputFormatters: [
                QuantityFormatter(),
              ],
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.deepOrange)),
                contentPadding: EdgeInsets.only(
                    bottom: 10.0, left: 10.0, right: 10.0, top: 10),
              ),
              cursorColor: Colors.deepOrange,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              Center(
                child: TextButton(
                  onPressed: () {
                    callBack?.call(() {}, _textFieldControllerDialog.text);
                    context.read<QSoftBloc>().add(
                        UpdateQuantityForBottomSheetEvent(
                            quantity: _textFieldControllerDialog.text));
                    Navigator.pop(context);
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
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  String? codeDialog;
  String? valueText;

  // Insert a new item to the database
  Future<void> _addItem(
      {required String sku,
      required String name,
      required String thumb,
      required String price,
      required int quantity}) async {
    await SQLHelper2.createItem(
        sku: sku, name: name, thumb: thumb, quantity: quantity, price: price);
  }

  void funcLog(String t) {}

  @override
  Widget build(BuildContext context) {
    _textFieldControllerBottomSheet =
        TextEditingController(text: widget.initialQuantity.toString());
    var isFirst = 1;
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      widget.product.thumb ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 160),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            widget.product.name ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: const Icon(
                                Icons.close,
                                size: 24,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 160),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 28,
                            child: BlocBuilder<QSoftBloc, QSoftState>(
                              buildWhen: (previous, current) =>
                                  previous != current &&
                                  current is UpdateQuantityForBottomSheetState,
                              builder: (context, state) {
                                if (state
                                    is UpdateQuantityForBottomSheetState) {
                                  var quantityUpdate = state.quantity;
                                  _textFieldControllerBottomSheet =
                                      TextEditingController(
                                          text: quantityUpdate);
                                  isFirst++;
                                }
                                return ProductQuantityInput(
                                  enabled: true,
                                  width: 100,
                                  height: 28,
                                  initCallback: (function) {},
                                  callBack: (func, quantity) {
                                    _displayTextInputDialog(
                                      context,
                                      quantity,
                                      (func, quantityUpdate) {
                                        func.call(); // call func in dialog
                                      },
                                    );
                                  },
                                  onQuantityChanged: (quantity, fromButton) {
                                    _textFieldControllerBottomSheet =
                                        TextEditingController(
                                            text: quantity.toString());
                                  },
                                  initialQuantity:
                                      _textFieldControllerBottomSheet.text,
                                  inputFlex: 2,
                                  quantityMax: 999,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  code: '',
                                  useFocusNode: false,
                                  useForCart: false,
                                );
                              },
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: NumberFormat("#,##0", "en_US").format(
                                  int.parse(widget.product.price ?? '0')),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.deepOrange),
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
                  ],
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    _addItem(
                        sku: widget.product.sku ?? '',
                        name: widget.product.name ?? '',
                        thumb: widget.product.thumb ?? '',
                        price: widget.product.price ?? '',
                        quantity:
                            int.parse(_textFieldControllerBottomSheet.text));
                    context.read<QSoftBloc>().add(AddToCartEvent(
                        quantityItemAdd: _textFieldControllerBottomSheet.text));
                    Navigator.pop(context, []);
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
                      'Add to cart',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
