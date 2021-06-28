import 'package:sample_food_order_app/core/models/order/order.dart';
import 'package:sample_food_order_app/core/models/product/product.dart';

int calculateOrderPrice(Product product, Order order) {
  final orderProduct = order.orderProduct;
  if (orderProduct == null) {
    return 0;
  }

  assert(product.id == orderProduct.productId);

  final int productPrice = product.getPrice(orderProduct.variantId) +
      order.modifications
          .fold(0, (acc, mod) => acc + product.getModificationPrice(mod));

  return productPrice * order.quantity;
}
