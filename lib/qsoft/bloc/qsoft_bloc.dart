import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/qsoft/model/product.model.dart';
import 'package:shopping_cart/qsoft/repository/qsoft_repo_impl.dart';
import 'package:shopping_cart/zcore/lib/bloc/bloc.core.dart';
import 'package:shopping_cart/zcore/sample_exception/src/sample_exception.dart';

part 'qsoft_event.dart';

part 'qsoft_state.dart';

class QSoftBloc extends CoreBloc<QSoftEvent, QSoftState> {
  QSoftBloc(initialState) : super(initialState) {
    on<GetProductEvent>(_onGetProductEvent);
    on<UpdateQuantityForBottomSheetEvent>(_onUpdateQuantityForBottomSheetEvent);
    on<UpdateQuantityForItemCartEvent>(_onUpdateQuantityForItemCartEvent);
    on<CreateBottomSheetEvent>(_onCreateBottomSheetEvent);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<DoneRefreshTotalItemCartEvent>(_onDoneRefreshTotalItemCartEvent);
    on<UpdateTotalCartEvent>(_onUpdateTotalCartEvent);
  }

  void _onGetProductEvent(
      GetProductEvent event, Emitter<QSoftState> emit) async {
    final res = await QSoftRepoImplement().getProduct();
    emit(ProductState(listProduct: res.listProduct));
  }

  @override
  void onErrorResolve(SampleException exception, bool resolved, {result}) {
    log("===onErrorResolve: ${exception.errorCode} ${exception.message}");
  }

  void _onUpdateQuantityForBottomSheetEvent(
      UpdateQuantityForBottomSheetEvent event, Emitter<QSoftState> emit) {
    emit(UpdateQuantityForBottomSheetState(quantity: event.quantity));
  }

  void _onCreateBottomSheetEvent(
      CreateBottomSheetEvent event, Emitter<QSoftState> emit) {
    emit(const CreateBottomSheetState());
  }

  void _onUpdateQuantityForItemCartEvent(
      UpdateQuantityForItemCartEvent event, Emitter<QSoftState> emit) {
    emit(
        UpdateQuantityForItemCartState(quantity: event.quantity, id: event.id));
  }

  void _onAddToCartEvent(AddToCartEvent event, Emitter<QSoftState> emit) {
    emit(const AddToCartState());
  }

  void _onDoneRefreshTotalItemCartEvent(DoneRefreshTotalItemCartEvent event, Emitter<QSoftState> emit) {
    emit(const DoneRefreshTotalItemCartState());
  }

  void _onUpdateTotalCartEvent(UpdateTotalCartEvent event, Emitter<QSoftState> emit) {
    emit(UpdateTotalCartState(total: event.total));
  }
}
