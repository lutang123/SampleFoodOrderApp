import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample_food_order_app/core/models/order/order_modification.dart';
import 'package:sample_food_order_app/core/models/order/order_product.dart';

@immutable
class Order extends Equatable {
  final OrderProduct? orderProduct;
  final List<OrderModification> modifications;
  final int quantity;

  Order._(this.orderProduct, this.modifications, this.quantity);

  factory Order.initial() => Order._(null, [], 0);
  factory Order.forProduct(OrderProduct orderProduct) =>
      Order._(orderProduct, [], 1);
  Order clearOrder() => Order.initial();

  Order copyWith({
    OrderProduct? orderProduct,
    List<OrderModification>? modifications,
    int? quantity,
  }) {
    return Order._(
      orderProduct ?? this.orderProduct,
      modifications ?? this.modifications,
      quantity ?? this.quantity,
    );
  }

  Order setVariant(int variantId) {
    return orderProduct == null
        ? this
        : copyWith(
            orderProduct: this.orderProduct?.copyWith(variantId: variantId),
          );
  }

  Order addModification(OrderModification modification) => this.copyWith(
      modifications: List.from(this.modifications)..add(modification));
  Order removeModification(OrderModification modification) => this.copyWith(
      modifications: List.from(this.modifications)..remove(modification));
  Order removeAllModifications(OrderModification modification) => this.copyWith(
      modifications: this
          .modifications
          .where((element) => element != modification)
          .toList());

  int getModificationCount(OrderModification orderModification) => modifications
      .fold(0, (acc, element) => element == orderModification ? acc + 1 : acc);

  int getGroupModificationCount(int groupId) => modifications.fold(
      0, (acc, element) => element.groupId == groupId ? acc + 1 : acc);

  @override
  List<Object?> get props => [orderProduct, modifications, quantity];

  @override
  bool? get stringify => true;
}
