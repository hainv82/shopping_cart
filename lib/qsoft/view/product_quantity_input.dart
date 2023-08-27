import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shopping_cart/qsoft/view/input_formatter.dart';

class ProductQuantityInput extends StatefulWidget {
  const ProductQuantityInput(
      {Key? key,
      this.initialQuantity = '1',
      this.height = 36,
      this.width = 90,
      required this.onQuantityChanged,
      this.inputStyle,
      this.inputFlex,
      this.onQuantityInputChanged,
      this.enabled = true,
      this.quantityMax,
      this.code,
      this.initCallback,
      this.callBack,
      required this.useFocusNode,
      this.focusNode,
      this.callBack2,
      required this.useForCart})
      : super(key: key);

  final String initialQuantity;
  final Function(int quantity, bool fromButton) onQuantityChanged;
  final Function(int quantity)? onQuantityInputChanged;
  final double height;
  final double width;
  final TextStyle? inputStyle;
  final int? inputFlex;
  final bool enabled;
  final bool useFocusNode;
  final bool useForCart;
  final int? quantityMax;
  final String? code;
  final FocusNode? focusNode;
  final Function(VoidCallback)? initCallback;
  final Function(VoidCallback, String)? callBack;
  final Function(Function(String) updateQuantityFunc, String quantity)?
      callBack2;

  @override
  State<ProductQuantityInput> createState() => _ProductQuantityInputState();
}

class _ProductQuantityInputState extends State<ProductQuantityInput> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();
  Timer? _timer;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    widget.initCallback?.call(() {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_controller.text.isEmpty || int.parse(_controller.text) == 0) {
        _updateQuantity(1, fromButton: true);
      } else {
        _updateQuantity(int.parse(_controller.text), fromButton: true);
      }
    });

    _controller = TextEditingController(text: widget.initialQuantity);
    super.initState();
    if (widget.useFocusNode) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus &&
            widget.initialQuantity != _controller.text) {
          if (_controller.text.isEmpty || int.parse(_controller.text) == 0) {
            _updateQuantity(1);
          } else {
            _updateQuantity(int.parse(_controller.text));
          }
        }
        if (_focusNode.hasFocus) {
          widget.callBack?.call(() {}, _controller.text);
        }
      });
      var keyboardVisibilityController = KeyboardVisibilityController();
      keyboardSubscription =
          keyboardVisibilityController.onChange.listen((bool visible) {
        if (!visible && _focusNode.hasFocus) {
          FocusScope.of(context).unfocus();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant ProductQuantityInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuantity != oldWidget.initialQuantity ||
        widget.quantityMax != null) {
      _controller
        ..text = widget.initialQuantity
        ..selection =
            TextSelection.collapsed(offset: widget.initialQuantity.length);
    }
  }

  @override
  void dispose() {
    if (widget.useFocusNode) {
      _focusNode.dispose();
    }
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onMinusPress() {
    final quantity = (int.tryParse(_controller.text) ?? 1) - 1;
    if (widget.useForCart) {}
    if (quantity > 0) {
      _updateQuantity(quantity, delayCallback: true);
    }
  }

  void _onPlusPress() {
    if (((int.tryParse(widget.initialQuantity) ?? 0) <
        (widget.quantityMax ?? 999))) {
      final quantity = (int.tryParse(_controller.text) ?? 1) + 1;
      final quantityM = (widget.quantityMax != null) ? widget.quantityMax : 999;
      if (quantity <= quantityM!) {
        _updateQuantity(quantity, delayCallback: true);
      } else {
        _updateQuantity(quantityM, delayCallback: true);
      }
    }
  }

  void _updateQuantity(
    int quantity, {
    bool delayCallback = false,
    bool fromButton = false,
  }) {
    _controller.value = TextEditingValue(
      text: '$quantity',
      selection: TextSelection.collapsed(
        offset: '$quantity'.length,
      ),
    );
    if (quantity > 0) {
      if (delayCallback) {
        if (_timer != null && _timer!.isActive) {
          _timer!.cancel();
        }
        _timer = Timer(const Duration(milliseconds: 300), () {
          widget.onQuantityChanged(quantity, fromButton);
          _timer = null;
        });
      } else {
        widget.onQuantityChanged(quantity, fromButton);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: _onMinusPress,
              child: Center(
                child: Image.asset(
                  'assets/images/icon_minus.png',
                  width: 11,
                  height: 3,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            width: 2,
            height: 36,
            color: Colors.blueGrey,
          ),
          Expanded(
            flex: widget.inputFlex ?? 1,
            child: TextFormField(
              enabled: widget.enabled,
              enableInteractiveSelection: false,
              onTap: () {
                //callback to show dialog
                widget.callBack?.call(() {}, _controller.text);

                widget.callBack2?.call((quantity) {}, _controller.text);
              },
              validator: (value) => int.tryParse(value ?? '1') == null
                  ? 'Số lượng không hợp lệ'
                  : null,
              focusNode: widget.useFocusNode ? _focusNode : widget.focusNode,
              controller: _controller,
              style: widget.inputStyle,
              inputFormatters: [
                QuantityFormatter(),
              ],
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 0,
                ),
              ),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(
            width: 2,
            height: 36,
            color: Colors.grey,
          ),
          Expanded(
            child: InkWell(
              onTap: widget.enabled ? _onPlusPress : null,
              child: Center(
                child: Image.asset(
                  ((int.tryParse(widget.initialQuantity) ?? 0) >=
                          (widget.quantityMax ?? 999))
                      ? 'assets/images/icon_plus_gray.png'
                      : 'assets/images/icon_plus.png',
                  width: 11,
                  height: 11,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
