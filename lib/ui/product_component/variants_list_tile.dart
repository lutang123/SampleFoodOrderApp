import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/constants.dart';
import 'package:sample_food_order_app/core/models/product/variant.dart';

import 'constant.dart';

class VariantsListView extends StatelessWidget {
  const VariantsListView({
    Key? key,
    required this.variants,
    required this.onChanged,
    required this.groupValue,
  }) : super(key: key);
  final List<Variant> variants;
  final void Function(Object?) onChanged;
  final dynamic groupValue;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: variants.length,
      itemBuilder: (context, int index) {
        final variant = variants[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: kPadding20 * 2),
          leading: Text(variant.name, style: kProductVariant),
          trailing: Radio(
            value: variant,
            groupValue: groupValue,
            activeColor: kPrimaryColor,
            onChanged: (Object? value) {
              onChanged(value);
            },
          ),
        );
      },
    );
  }
}

class VariantListTile extends StatelessWidget {
  const VariantListTile({
    Key? key,
    required this.variant,
    required this.selectedVariantId,
    required this.onChanged,
  }) : super(key: key);

  final Variant variant;
  final int? selectedVariantId;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: kPadding20 * 2, vertical: 10),
          leading: Text(variant.name, style: kProductVariant),
          trailing: Radio(
            value: variant.id,
            groupValue: selectedVariantId,
            activeColor: kPrimaryColor,
            onChanged: (Object? id) {
              onChanged(id as int);
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
