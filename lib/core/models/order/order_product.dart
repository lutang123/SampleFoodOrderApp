import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class OrderProduct extends Equatable {
  final int productId;
  final int variantId;

  OrderProduct({
    required this.productId,
    required this.variantId,
  });

  OrderProduct copyWith({
    int? productId,
    int? variantId,
  }) {
    return OrderProduct(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
    );
  }

  @override
  List<Object?> get props => [productId, variantId];
  @override
  bool get stringify => true;
}
