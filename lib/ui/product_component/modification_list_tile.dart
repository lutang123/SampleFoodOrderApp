import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/constants.dart';
import 'package:sample_food_order_app/core/models/order/order_modification.dart';
import 'package:sample_food_order_app/core/models/product/modification_group.dart';
import 'package:sample_food_order_app/core/services/format.dart';
import 'package:sample_food_order_app/ui/product_component/quantity_row.dart';

import 'constant.dart';

class ModificationListTile extends StatelessWidget {
  const ModificationListTile({
    required this.modificationGroup,
    required this.getQuantityInOrder,
    required this.onAddModification,
    required this.onRemoveModification,
    required this.onRemoveAllModifications,
  });

  final ModificationGroup modificationGroup;
  final void Function(OrderModification) onAddModification;
  final void Function(OrderModification) onRemoveModification;
  final void Function(OrderModification) onRemoveAllModifications;
  final int Function(OrderModification) getQuantityInOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(),
        ...modificationGroup.modifications.map((modification) {
          final orderModification = OrderModification(
              groupId: modificationGroup.id, modificationId: modification.id);

          final modificationQuantity = getQuantityInOrder(orderModification);

          return Column(
            children: [
              ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: kPadding20 * 2),
                leading: modification.price == 0
                    ? Text(modification.name, style: kProductVariant)
                    : Text(
                        '${modification.name} - add ${currency(modification.price)}',
                        style: kProductVariant),
                title: modificationQuantity > 0 && modification.allowQuantity
                    ? ModificationQuantityRow(
                        quantity: modificationQuantity,
                        onPressedPlus: () =>
                            onAddModification(orderModification),
                        onPressedMinus: () =>
                            onRemoveModification(orderModification),
                      )
                    : const SizedBox(),
                trailing: Checkbox(
                  value: modificationQuantity > 0,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    final isChecked = value ?? false;
                    if (isChecked && modificationQuantity == 0) {
                      onAddModification(orderModification);
                    } else if (!isChecked) {
                      onRemoveAllModifications(orderModification);
                    }
                  },
                ),
              ),
              const Divider(height: 1),
            ],
          );
        }).toList(),
      ],
    );
  }

  Container buildTitle() {
    return Container(
      color: kLightGrey,
      child: Padding(
        padding: const EdgeInsets.only(left: kPadding20, top: 8.0, bottom: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            modificationGroup.required
                ? Text(modificationGroup.name, style: kHeaderTextStyle)
                : Text('${modificationGroup.name} (add-on)',
                    style: kHeaderTextStyle),
            modificationGroup.required
                ? modificationGroup.maximum == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 3),
                        child: Text('Choose as many as you would like',
                            style: kGrayStyle14),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 3),
                        child: Text('Choose up to ${modificationGroup.maximum}',
                            style: kGrayStyle14),
                      )
                //mini is null
                : modificationGroup.maximum == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 3),
                        child: Text('Choose as many as you would like',
                            style: kGrayStyle14),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 3),
                        child: Text('Choose up to ${modificationGroup.maximum}',
                            style: kGrayStyle14),
                      ),
          ],
        ),
      ),
    );
  }
}
