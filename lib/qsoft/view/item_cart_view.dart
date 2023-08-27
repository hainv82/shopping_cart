import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_cart/qsoft/bloc/qsoft_bloc.dart';
import 'package:shopping_cart/qsoft/model/items_cart.model.dart';
import 'package:shopping_cart/qsoft/view/input_formatter.dart';
import 'package:shopping_cart/qsoft/view/product_quantity_input.dart';

class ItemCartView extends StatefulWidget {
  final ItemCart data;
  final Function(ItemCart) onPlus;
  final Function(ItemCart) onMinus;
  final Function(String a) onDelete;
  final Function(int quantity, bool fromButton) onQuantityChanged;
  final Function(ItemCart, String) callBackUpdateQuantity;

  const ItemCartView(
      {Key? key,
      required this.data,
      required this.onPlus,
      required this.onMinus,
      required this.onDelete,
      required this.callBackUpdateQuantity,
      required this.onQuantityChanged})
      : super(key: key);

  @override
  State<ItemCartView> createState() => _ItemCartViewState();
}

class _ItemCartViewState extends State<ItemCartView> {
  late TextEditingController _textFieldControllerItemCart;

  late TextEditingController _textFieldControllerDialog;

  Future<void> _displayTextInputDialog(BuildContext context, String quantity,
      Function(VoidCallback, String)? callBack) async {
    _textFieldControllerDialog = TextEditingController(text: quantity);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.data.name),
            content: TextFormField(
              enabled: true,
              onTap: () {},
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
                    Navigator.pop(context);
                    widget.callBackUpdateQuantity
                        .call(widget.data, _textFieldControllerDialog.text);
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

  @override
  Widget build(BuildContext context) {
    _textFieldControllerItemCart =
        TextEditingController(text: widget.data.quantity.toString());
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 140,
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Row(
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
                    widget.data.thumb ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.data.name ?? '',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onDelete.call(widget.data.id.toString());
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: const Icon(
                              Icons.close,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 200),
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
                                current is UpdateQuantityForItemCartState,
                            builder: (context, state) {
                              if (state is UpdateQuantityForItemCartState) {
                                if (widget.data.id == state.id) {
                                  var quantityUpdate = state.quantity;
                                  _textFieldControllerItemCart =
                                      TextEditingController(
                                          text: quantityUpdate);
                                }
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
                                callBack2: (fun, quantity) {},
                                onQuantityChanged: widget.onQuantityChanged,
                                initialQuantity:
                                    _textFieldControllerItemCart.text,
                                inputFlex: 2,
                                quantityMax: 999,
                                focusNode: AlwaysDisabledFocusNode(),
                                code: '',
                                useFocusNode: false,
                                useForCart: true,
                              );
                            },
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: NumberFormat("#,##0", "en_US")
                                .format(int.parse(widget.data.price ?? '0')),
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
        ),
      ),
    );
  }
}
