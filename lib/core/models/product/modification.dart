class Modification {
  Modification({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.allowQuantity = false,
    required this.variant,
    required this.modificationGroup,
  });

  int id;
  String name;
  String? description;
  int price;
  bool allowQuantity;
  int variant;
  int modificationGroup;

  factory Modification.fromJson(dynamic json) {
    int variant;
    int modificationGroup;

    try {
      variant = json["variant"] as int;
    } catch (e) {
      variant = json["variant"]["id"] as int;
    }

    try {
      modificationGroup = json["modification_group"] as int;
    } catch (e) {
      modificationGroup = json["modification_group"]["id"] as int;
    }

    return Modification(
      id: json["id"] as int,
      name: json["name"].toString(),
      description: json["description"]?.toString(),
      price: int.parse(json["price"].toString()),
      allowQuantity: json["allow_quantity"] == true,
      variant: variant,
      modificationGroup: modificationGroup,
    );
  }
}
