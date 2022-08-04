import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_simple_base_project/core/data_types.dart';

class SelectableItem extends Equatable {
  final int id;
  final String name;
  late final BoolVs isSelected = BoolVs(false);

  SelectableItem({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name, isSelected.value];
}

class SelectableItemVs extends ValueNotifier<SelectableItem> {
  SelectableItemVs(SelectableItem value) : super(value);
}

class NullableSelectableItemVs extends ValueNotifier<SelectableItem?> {
  NullableSelectableItemVs([SelectableItem? value]) : super(value);
}
