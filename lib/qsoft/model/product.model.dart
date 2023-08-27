import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.model.g.dart';

@JsonSerializable()
class Product extends Equatable {
  @JsonKey(name: 'sku')
  final String? sku;
  @JsonKey(name: 'thumb')
  final String? thumb;
  @JsonKey(name: 'img')
  final String? img;
  @JsonKey(name: 'price')
  final String? price;
  @JsonKey(name: 'name')
  final String? name;

  const Product({this.sku, this.thumb, this.img, this.price, this.name});

  static Product fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @override
  List<Object?> get props => [sku, thumb, img, price, name];
}
