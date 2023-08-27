part of 'qsoft_bloc.dart';

abstract class QSoftState extends Equatable {
  const QSoftState();

  @override
  List<Object?> get props => [];
}

class QSoftInitial extends QSoftState {
  const QSoftInitial();
}

class ProductState extends QSoftState {
  final List<Product> listProduct;

  const ProductState({required this.listProduct});

  @override
  List<Object?> get props => [listProduct];
}

class UpdateQuantityForBottomSheetState extends QSoftState {
  final String quantity;

  const UpdateQuantityForBottomSheetState({required this.quantity});

  @override
  List<Object?> get props => [quantity];
}

class UpdateQuantityForItemCartState extends QSoftState {
  final String quantity;
  final int id;

  const UpdateQuantityForItemCartState(
      {required this.quantity, required this.id});

  @override
  List<Object?> get props => [quantity];
}
class DoneUpdateItemCartState extends QSoftState{

  const DoneUpdateItemCartState();
}

class CreateBottomSheetState extends QSoftState {
  const CreateBottomSheetState();
}

class AddToCartState extends QSoftState {
  const AddToCartState();
}

class DoneRefreshTotalItemCartState extends QSoftState {
  const DoneRefreshTotalItemCartState();
}

class UpdateTotalCartState extends QSoftState {
  final int total;

  const UpdateTotalCartState({required this.total});
  @override
  List<Object?> get props => [total];
}
