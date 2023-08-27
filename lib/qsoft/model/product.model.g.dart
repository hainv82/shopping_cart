// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      sku: json['sku'] as String?,
      thumb: json['thumb'] as String?,
      img: json['img'] as String?,
      price: json['price'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'sku': instance.sku,
      'thumb': instance.thumb,
      'img': instance.img,
      'price': instance.price,
      'name': instance.name,
    };
