part of 'qsoft_bloc.dart';

class QSoftEvent {
  QSoftEvent();
}

class GetProductEvent extends QSoftEvent {
  GetProductEvent();
}

class UpdateQuantityForBottomSheetEvent extends QSoftEvent {
  final String quantity;

  UpdateQuantityForBottomSheetEvent({required this.quantity});
}

class UpdateQuantityForItemCartEvent extends QSoftEvent {
  final String quantity;
  final int id;

  UpdateQuantityForItemCartEvent({required this.quantity, required this.id});
}

class DoneUpdateItemCartEvent extends QSoftEvent{

  DoneUpdateItemCartEvent();
}

class CreateBottomSheetEvent extends QSoftEvent {
  CreateBottomSheetEvent();
}

class AddToCartEvent extends QSoftEvent{
  final String quantityItemAdd;
  AddToCartEvent({required this.quantityItemAdd});
}

class DoneRefreshTotalItemCartEvent extends QSoftEvent{

  DoneRefreshTotalItemCartEvent();
}

class UpdateTotalCartEvent extends QSoftEvent{
  final int total;
  UpdateTotalCartEvent({required this.total});
}