import 'package:flutter/foundation.dart';

/// To trace [get] or [set] statements, using [TsxInt].
class SxInt extends ValueNotifier<int> {
  SxInt(int value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TsxInt extends SxInt {
  TsxInt(int value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  int get value => super.value;

  @override
  set value(int newValue) {
    super.value = newValue;
  }
}

/// To trace [get] or [set] statements, using [TsxDouble].
class SxDouble extends ValueNotifier<double> {
  SxDouble(double value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TsxDouble extends SxDouble {
  TsxDouble(double value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  double get value => super.value;

  @override
  set value(double newValue) {
    super.value = newValue;
  }
}

/// To trace [get] or [set] statements, using [TsxString].
class SxString extends ValueNotifier<String> {
  SxString(String value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TsxString extends SxString {
  TsxString(String value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  String get value => super.value;

  @override
  set value(String newValue) {
    super.value = newValue;
  }
}

/// To trace [get] or [set] statements, using [TsxBool].
class SxBool extends ValueNotifier<bool> {
  SxBool(bool value) : super(value);

  void toggle() => value = !value;
}

/// Used to trace [get] or [set] statements.
class TsxBool extends SxBool {
  TsxBool(bool value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  bool get value => super.value;

  @override
  set value(bool newValue) {
    super.value = newValue;
  }
}

/// To trace [get] or [set] statements, using [TsxList].
class SxList<E> extends ValueNotifier<List<E>> {
  SxList(List<E> value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TsxList<E> extends SxList<E> {
  TsxList(List<E> value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  List<E> get value => super.value;

  @override
  set value(List<E> newValue) {
    super.value = newValue;
  }
}

/*
/// To trace [get] or [set] statements, using [TsxSet].
class SxSet<E> extends ValueNotifier<Set<E>> {
  SxSet(Set<E> value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TsxSet<E> extends SxSet<E> {
  TsxSet(Set<E> value) : super(value);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  Set<E> get value => super.value;

  @override
  set value(Set<E> newValue) {
    super.value = newValue;
  }
}
*/