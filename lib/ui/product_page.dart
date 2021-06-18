import 'package:flutter/material.dart';
import 'package:sample_food_order_app/core/constants.dart';
import 'package:sample_food_order_app/core/api_service/product_testfile.dart';
import 'package:sample_food_order_app/core/models/product/modification.dart';
import 'package:sample_food_order_app/core/models/product/modification_group.dart';
import 'package:sample_food_order_app/core/models/product/product.dart';
import 'package:sample_food_order_app/core/models/product/variant.dart';
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
  late Product product;
  Variant? _selectedVariant;
  List<ModificationGroup>? modifications;

  bool _isLoading = true;
  bool _hasError = false;

  int variantPrice = 0;
  int modificationPrice = 0;
  int totalPrice = 0;
  double displayedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    getProductFromAPI();
  }

  Future<void> getProductFromAPI() async {
    product = getProductFromTest();
    _getSelectedVariant(product);
    _sortModificationGroup(product);
    setState(() {
      _isLoading = false;
    });
  }

  void _getSelectedVariant(Product product) {
    if (product.variants.isNotEmpty) {
      setState(() {
        _selectedVariant = product.variants[0];
        variantPrice = _selectedVariant!.price;
        getDisplayedPrice();
      });
    }
  }

  void _sortModificationGroup(Product product) {
    modifications = product.modificationGroups;
    if (modifications != null) {
      modifications!
          .sort((lhs, rhs) => (lhs.required.toString().length) //true 4
                  .compareTo(rhs.required.toString().length) //false 5 )
              );
    }
  }

  void addToCart() => Navigator.of(context).pop();

  void getDisplayedPrice() {
    totalPrice = variantPrice * _variantQuantity + modificationPrice;
    displayedPrice = totalPrice / 100;
  }

  /// variant
  int _variantQuantity = 1;

  void _onChangedVariant(value) {
    setState(() {
      _selectedVariant = value as Variant;
      variantPrice = _selectedVariant!.price;
      getDisplayedPrice();
    });
  }

  void _onPressedPlusVariant() {
    setState(() {
      _variantQuantity += 1;
      getDisplayedPrice();
    });
  }

  void _onPressedMinusVariant() {
    if (_variantQuantity > 1) {
      setState(() {
        _variantQuantity -= 1;
        getDisplayedPrice();
      });
    }
  }

  ///modification
  //this is the default number on plus and minus button on modification
  int _modificationQuantity = 1;
  //this is supposed to be the variable to tract how much modification items
  //user has selected, and if maxQuantity is not null, this number should be smaller
  //than maxQuantity.
  int selectedModificationItem = 0;

  void _onChangedModification(
      bool? value, Modification modification, int? maxQuantity) {
    setState(
      () {
        modification.isSelected = !modification.isSelected;

        if ((value == true) && (_modificationQuantity == 1)) {
          // modification.isSelected = false;
          modificationPrice = _modificationQuantity * modification.price;
          getDisplayedPrice();
        } else if (value == false) {
          //in this case, user unchecked the modification box, we reset this to default
          _modificationQuantity = 1;
          //and we have to reset the price too
          modificationPrice = 0;
          getDisplayedPrice();
        }
      },
    );
    print('_selectedModificationItem: $selectedModificationItem');
    print('_modificationQuantity: $_modificationQuantity');
    print('totalprice: $totalPrice');
  }

  void _onPressedPlusModification(Modification modification, int? maxQuantity) {
    if (maxQuantity != null) {
      if (_modificationQuantity < maxQuantity) {
        setState(() {
          _modificationQuantity += 1;
          modificationPrice = _modificationQuantity * modification.price;
          getDisplayedPrice();
        });
      } else {
        showAlertDialog(context,
            title: 'Error',
            content: Text('You can choose maximum of $maxQuantity items'));
      }
    }
    print('_modificationQuantity: $_modificationQuantity');
    print('totalprice: $totalPrice');
  }

  void _onPressedMinusModification(Modification modification) {
    if (_modificationQuantity > 1) {
      setState(() {
        _modificationQuantity -= 1;
        modificationPrice = _modificationQuantity * modification.price;
        getDisplayedPrice();
      });
    }
    print('_modificationQuantity: $_modificationQuantity');
    print('totalprice: $totalPrice');
  }

  //<--------UI---------------------------------->
  @override
  Widget build(BuildContext context) {
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
          product.name,
          style: const TextStyle(color: kMainTextColor),
        ),
      ),
      body: _buildProductBody(),
    );
  }

  Widget _buildProductBody() {
    return _isLoading
        ? const CircularProgressIndicator(color: kPrimaryColor)
        : _hasError
            ? buildErrorWidget()
            : Stack(
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
                              padding: EdgeInsets.only(
                                  left: 20, top: 10.0, bottom: 10),
                              child: Text("Choose One ",
                                  style: kHeaderTextStyle,
                                  textAlign: TextAlign.left),
                            ),
                          ),
                        if (product.variants.length > 1)
                          ...product.variants.map(
                            (variant) => VariantListTile(
                              variant: variant,
                              groupValue: _selectedVariant,
                              onChanged: _onChangedVariant,
                            ),
                          ),
                        if (product.modificationGroups != null)
                          ...product.modificationGroups!
                              .map(
                                (modificationGroup) => ModificationListTile(
                                  modificationGroup: modificationGroup,
                                  onPressedMinusModification:
                                      _onPressedMinusModification,
                                  onChangedModification: _onChangedModification,
                                  modificationQuantity: _modificationQuantity,
                                  onPressedPlusModification:
                                      _onPressedPlusModification,
                                ),
                              )
                              .toList(),
                        buildQuantityButtons(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                  buildStackedButton(),
                  buildStackedBottom()
                ],
              );
  }

  Container buildQuantityButtons() {
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
            variantQuantity: _variantQuantity,
            onPressedPlus: _onPressedPlusVariant,
            onPressedMinus: _onPressedMinusVariant,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Padding buildStackedButton() {
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
                Text('\$$displayedPrice',
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

  Center buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text('EmptyOrErrorContent.error_message',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
