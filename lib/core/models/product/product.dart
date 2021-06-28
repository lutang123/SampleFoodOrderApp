import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sample_food_order_app/core/models/order/order_modification.dart';

import './modification_group.dart';
import './variant.dart';

@immutable
class Product {
  final int id; //6116
  final String name;
  final String? description;
  final String? featuredImage; //null
  final List<ModificationGroup> modificationGroups; //[]
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.featuredImage,
    List<ModificationGroup>? modificationGroups,
    required this.variants,
  }) : this.modificationGroups = modificationGroups ?? [];

  factory Product.fromJson(String str) =>
      Product.fromMap(json.decode(str) as Map<String, dynamic>);

  factory Product.fromMap(Map<String, dynamic> json) {
    final _featuredImage = json["featured_image"] == null
        ? null
        : json["featured_image"]["url"].toString();

    final List _modificationGroups = (json["modification_groups"] == null ||
            json["modification_groups"] == [])
        ? []
        : (json["modification_groups"] as List<dynamic>)
            .map((x) => ModificationGroup.fromJson(x))
            .toList();

    final List _variants = (json["variants"] == null || json["variants"] == [])
        ? []
        : (json["variants"] as List<dynamic>)
            .map((x) => Variant.fromJson(x))
            .toList();

    return Product(
      id: json["id"] as int,
      name: json["name"].toString(),
      description: json["description"]?.toString(),
      featuredImage: _featuredImage,
      modificationGroups: _modificationGroups as List<ModificationGroup>?,
      variants: _variants as List<Variant>,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, featuredImage: $featuredImage, modificationGroups: $modificationGroups, variants: $variants)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.featuredImage == featuredImage &&
        listEquals(other.modificationGroups, modificationGroups) &&
        listEquals(other.variants, variants);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        featuredImage.hashCode ^
        modificationGroups.hashCode ^
        variants.hashCode;
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? featuredImage,
    List<ModificationGroup>? modificationGroups,
    List<Variant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      featuredImage: featuredImage ?? this.featuredImage,
      modificationGroups: modificationGroups ?? this.modificationGroups,
      variants: variants ?? this.variants,
    );
  }

  int getPrice(int variantId) {
    final variant =
        variants.firstWhereOrNull((variant) => variant.id == variantId);

    if (variant == null) {
      print("Error: Variant id $variantId was not found!");
      return 0;
    }

    return variant.price;
  }

  ModificationGroup? findModificationGroup(int groupId) {
    return modificationGroups.firstWhereOrNull((g) => g.id == groupId);
  }

  int getModificationPrice(OrderModification modification) {
    final modificationGroup = findModificationGroup(modification.groupId);

    if (modificationGroup == null) {
      print(
          "Error: modification group ${modification.groupId} not found in product $id");
      return 0;
    }

    return modificationGroup.getModificationPrice(modification.modificationId);
  }
}
