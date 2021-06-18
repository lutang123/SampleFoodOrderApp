import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/constants.dart';

import 'constant.dart';

class QuantityRow extends StatelessWidget {
  const QuantityRow({
    Key? key,
    required this.variantQuantity,
    required this.onPressedPlus,
    required this.onPressedMinus,
  }) : super(key: key);

  final int variantQuantity;
  final VoidCallback onPressedPlus;
  final VoidCallback onPressedMinus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20 * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              style: TextButton.styleFrom(
                elevation: 0.0,
                backgroundColor: kDarkButtonColor,
              ),
              onPressed: onPressedMinus,
              child: const Text(
                "-",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: kDarkButtonColor),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text('$variantQuantity', style: kProductVariant),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              style: TextButton.styleFrom(
                elevation: 0.0,
                backgroundColor: kDarkButtonColor,
              ),
              onPressed: onPressedPlus,
              child: const Text(
                "+",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModificationQuantityRow extends StatelessWidget {
  const ModificationQuantityRow({
    Key? key,
    required this.quantity,
    required this.onPressedPlus,
    required this.onPressedMinus,
  }) : super(key: key);

  final int quantity;
  final VoidCallback onPressedPlus;
  final VoidCallback onPressedMinus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildPlusButton("-", onPressedMinus),
          Container(
            width: 20,
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: kDarkButtonColor),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('$quantity', style: kProductVariant),
              ),
            ),
          ),
          buildPlusButton("+", onPressedPlus),
        ],
      ),
    );
  }

  SizedBox buildPlusButton(String text, VoidCallback onPressedMinus) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Center(
        child: ElevatedButton(
          style: TextButton.styleFrom(
            elevation: 0.0,
            backgroundColor: kDarkButtonColor,
          ),
          onPressed: onPressedMinus,
          child: Text(
            text,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
