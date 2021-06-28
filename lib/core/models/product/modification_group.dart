import 'package:collection/collection.dart';

import 'modification.dart';

class ModificationGroup {
  int id;
  String name;
  String? description;
  bool required;
  int? minimum;
  int? maximum;
  String? featuredImage;
  List<Modification> modifications;

  //if min and max are all null, user can select any item
  //if min == null, max = 2, total item quantity is max
  //if min != null, max is null,
  ModificationGroup({
    required this.id,
    required this.name,
    this.description,
    this.required = false,
    this.minimum,
    this.maximum,
    this.featuredImage,
    this.modifications = const [],
  });

  factory ModificationGroup.fromJson(dynamic json) {
    final _modifications =
        (json["modifications"] == null || json["modifications"] == [])
            ? []
            : (json["modifications"] as List<dynamic>)
                .map((x) => Modification.fromJson(x))
                .toList();

    return ModificationGroup(
      id: json["id"] as int,
      name: json["name"].toString(),
      description: json["description"]?.toString(),
      required: json["required"] == true,
      minimum: json["minimum"] != null ? json["minimum"] as int : null,
      maximum: json["maximum"] != null ? json["maximum"] as int : null,
      modifications: _modifications as List<Modification>,
    );
  }

  int getModificationPrice(int modificationId) {
    final modification =
        modifications.firstWhereOrNull((m) => m.id == modificationId);
    if (modification == null) {
      print("Error: modification $modificationId not found in group $id");
      return 0;
    }

    return modification.price;
  }
}
