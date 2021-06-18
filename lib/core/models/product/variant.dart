class Variant {
  final int id; //6077
  final String name;
  final int price; //"500"
  final int? displayPrice; //"500"
  final String? sku;
  final bool? isPhysicalProduct; //true
  final bool? isGiftCard; //false
  final bool isDefault; //true
  final bool? isTaxable; //true
  final int product; // 6116
  final String? featuredImage; //null

  const Variant({
    required this.id,
    required this.name,
    required this.price,
    this.displayPrice,
    this.sku,
    this.isPhysicalProduct,
    this.isGiftCard,
    required this.isDefault,
    this.isTaxable,
    required this.product,
    this.featuredImage,
  });

  factory Variant.fromJson(dynamic json) {
    final _price = int.parse(json["price"].toString());

    final _displayPrice = json["display_price"] != null
        ? int.parse(json["display_price"].toString())
        : null;

    final _sku = json["sku"]?.toString();

    int product;
    try {
      product = json["product"] as int;
    } catch (e) {
      product = json["product"]["id"] as int;
    }

    return Variant(
      id: json["id"] as int,
      name: json["name"].toString(),
      price: _price,
      displayPrice: _displayPrice,
      sku: _sku,
      isPhysicalProduct: json["is_physical_product"] == true,
      isGiftCard: json["is_gift_card"] == true,
      isDefault: json["is_default"] == true,
      isTaxable: json["is_taxable"] == true,
      product: product,
      featuredImage: json["featured_image"] != null
          ? json["featured_image"]["url"].toString()
          : null,
    );
  }
}
