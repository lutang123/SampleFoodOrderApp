import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/api_service/product_testfile.dart';
import 'package:sample_food_order_app/core/constants.dart';
import 'package:sample_food_order_app/core/models/order/order.dart';
import 'package:sample_food_order_app/core/models/order/order_modification.dart';
import 'package:sample_food_order_app/core/models/order/order_product.dart';
import 'package:sample_food_order_app/core/models/product/modification_group.dart';
import 'package:sample_food_order_app/core/models/product/product.dart';
import 'package:sample_food_order_app/core/services/format.dart';
import 'package:sample_food_order_app/core/services/price_calculator.dart';
import 'package:sample_food_order_app/ui/product_component/constant.dart';
import 'package:sample_food_order_app/ui/product_component/modification_list_tile.dart';
import 'package:sample_food_order_app/ui/product_component/quantity_row.dart';
import 'package:sample_food_order_app/ui/product_component/show_alert_dialog.dart';
import 'package:sample_food_order_app/ui/product_component/variants_list_tile.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product> productFromNetwork;
  final _orderController = StreamController<Order>();

  @override
  void initState() {
    super.initState();

    _orderController.add(Order.initial());
    productFromNetwork = getProductFromTest();

    productFromNetwork.then((product) {
      assert(product.variants.isNotEmpty);
      final orderProduct = OrderProduct(
          productId: product.id, variantId: product.variants.first.id);
      _orderController.add(Order.forProduct(orderProduct));
    });

    setState(() {});
  }

  @override
  void dispose() {
    _orderController.close();
    super.dispose();
  }

  List<ModificationGroup> _sortedModificationGroup(Product product) {
    return List.from(product.modificationGroups)
      ..sort((lhs, rhs) => (lhs.required.toString().length) //true 4
              .compareTo(rhs.required.toString().length) //false 5 )
          );
  }

  void addToCart() => Navigator.of(context).pop();

  void _onChangedVariant(Order order, int variantId) {
    final updatedOrder = order.setVariant(variantId);
    _orderController.add(updatedOrder);
  }

  void _onPressedPlusVariant(Order order) {
    final updated = order.copyWith(quantity: order.quantity + 1);
    _orderController.add(updated);
  }

  void _onPressedMinusVariant(Order order) {
    if (order.quantity <= 1) {
      return;
    }

    final updated = order.copyWith(quantity: order.quantity - 1);
    _orderController.add(updated);
  }

  void _onAddModification(
      Product product, Order order, OrderModification orderMod) {
    final modGroup = product.findModificationGroup(orderMod.groupId);

    if (modGroup == null) {
      return;
    }

    if (modGroup.maximum == null ||
        order.getGroupModificationCount(orderMod.groupId) < modGroup.maximum!) {
      final updatedOrder = order.addModification(orderMod);
      _orderController.add(updatedOrder);
    } else {
      showAlertDialog(context,
          title: 'Error',
          content:
              Text('You can choose maximum of ${modGroup.maximum!} items'));
    }
  }

  void _onRemoveModification(Order order, OrderModification orderMod) {
    final updatedOrder = order.removeModification(orderMod);
    _orderController.add(updatedOrder);
  }

  void _onRemoveAllModifications(Order order, OrderModification orderMod) {
    final updatedOrder = order.removeAllModifications(orderMod);
    _orderController.add(updatedOrder);
  }

  //<--------UI---------------------------------->
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: productFromNetwork,
      builder: (context, snapshot) {
        late Widget body;
        late String title;
        if (snapshot.hasData) {
          title = snapshot.data!.name;
          body = _buildProductBody(snapshot.data!);
        } else if (snapshot.hasError) {
          title = "Error!";
          body = _buildErrorWidget(snapshot.error!);
        } else {
          title = "Loading";
          body = const CircularProgressIndicator(color: kPrimaryColor);
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                color: kGreyTextColor,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(color: kMainTextColor),
            ),
          ),
          body: body,
        );
      },
    );
  }

  Widget _buildProductBody(Product product) {
    return StreamBuilder<Order>(
        stream: _orderController.stream,
        builder: (context, snapshot) {
          final order = snapshot.data;
          if (order == null) {
            return SizedBox();
          }

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (product.variants.length > 1)
                      Container(
                        color: kLightGrey,
                        child: const Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 10.0, bottom: 10),
                          child: Text("Choose One ",
                              style: kHeaderTextStyle,
                              textAlign: TextAlign.left),
                        ),
                      ),
                    if (product.variants.length > 1)
                      ...product.variants.map(
                        (variant) => VariantListTile(
                          variant: variant,
                          selectedVariantId: order.orderProduct?.variantId,
                          onChanged: (variantId) =>
                              _onChangedVariant(order, variantId),
                        ),
                      ),
                    ..._sortedModificationGroup(product)
                        .map(
                          (modificationGroup) => ModificationListTile(
                            modificationGroup: modificationGroup,
                            getQuantityInOrder: order.getModificationCount,
                            onAddModification: (mod) =>
                                _onAddModification(product, order, mod),
                            onRemoveModification: (mod) =>
                                _onRemoveModification(order, mod),
                            onRemoveAllModifications: (mod) =>
                                _onRemoveAllModifications(order, mod),
                          ),
                        )
                        .toList(),
                    buildQuantityButtons(order),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              buildStackedButton(calculateOrderPrice(product, order)),
              buildStackedBottom()
            ],
          );
        });
  }

  Container buildQuantityButtons(Order order) {
    return Container(
      color: kLightGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10.0, bottom: 10),
            child: Text("How Many ?",
                style: kHeaderTextStyle, textAlign: TextAlign.left),
          ),
          QuantityRow(
            variantQuantity: order.quantity,
            onPressedPlus: () => _onPressedPlusVariant(order),
            onPressedMinus: () => _onPressedMinusVariant(order),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Padding buildStackedButton(int price) {
    return Padding(
      padding: const EdgeInsets.only(
          left: kPadding20, right: kPadding20, bottom: 30),
      child: Container(
        height: 40,
        child: ElevatedButton(
          onPressed: addToCart,
          style: TextButton.styleFrom(
            backgroundColor: kPrimaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  'Add to Chart'.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                Text('${currency(price)}',
                    style: const TextStyle(color: Colors.white, fontSize: 18))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildStackedBottom() {
    return Container(
      height: 30,
      color: kLightBkgdColor,
    );
  }

  Center _buildErrorWidget(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(error.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
