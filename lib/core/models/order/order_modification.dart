import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class OrderModification extends Equatable {
  final int groupId;
  final int modificationId;

  OrderModification({
    required this.groupId,
    required this.modificationId,
  });

  @override
  List<Object?> get props => [groupId, modificationId];

  @override
  bool? get stringify => true;
}
