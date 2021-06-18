import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/constants.dart';
import 'package:sample_food_order_app/core/models/product/modification.dart';
import 'package:sample_food_order_app/core/models/product/modification_group.dart';
import 'package:sample_food_order_app/ui/product_component/quantity_row.dart';
import 'constant.dart';

class ModificationListTile extends StatelessWidget {
  const ModificationListTile({
    Key? key,
    required this.modificationGroup,
    required this.onChangedModification,
    required this.modificationQuantity,
    required this.onPressedPlusModification,
    required this.onPressedMinusModification,
  }) : super(key: key);
  final ModificationGroup modificationGroup;
  final void Function(bool?, Modification modification, int? maxQuantity)
      onChangedModification;

  final int modificationQuantity;
  final Function(Modification modification, int? maxQuantity)
      onPressedPlusModification;
  final Function(Modification modification) onPressedMinusModification;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: kLightGrey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: kPadding20, top: 8.0, bottom: 8.0),
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
                            child: Text(
                                'Choose up to ${modificationGroup.maximum}',
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
                            child: Text(
                                'Choose up to ${modificationGroup.maximum}',
                                style: kGrayStyle14),
                          ),
              ],
            ),
          ),
        ),
        ...modificationGroup.modifications.map((modification) {
          return Column(
            children: [
              ListTile(
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: kPadding20 * 2),
                leading: modification.price == 0
                    ? Text(modification.name, style: kProductVariant)
                    : Text(
                        '${modification.name} - add \$${modification.price / 100}',
                        style: kProductVariant),
                title: modification.isSelected && modification.allowQuantity
                    ? ModificationQuantityRow(
                        quantity: modificationQuantity,
                        onPressedPlus: () => onPressedPlusModification(
                            modification, modificationGroup.maximum),
                        onPressedMinus: () =>
                            onPressedMinusModification(modification),
                      )
                    : const SizedBox(),
                trailing: Checkbox(
                  value: modification.isSelected,
                  activeColor: kPrimaryColor,
                  onChanged: (value) => onChangedModification(
                      value, modification, modificationGroup.maximum),
                ),
              ),
              const Divider(height: 1),
            ],
          );
        }).toList(),
      ],
    );
  }
}
