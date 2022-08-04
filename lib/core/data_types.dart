import 'package:flutter/foundation.dart';

/// To trace [get] or [set] statements, using [TraceableIntVs].
class IntVs extends ValueNotifier<int> {
  IntVs(int value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TraceableIntVs extends IntVs {
  TraceableIntVs(int value) : super(value);

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

/// To trace [get] or [set] statements, using [TraceableDoubleVs].
class DoubleVs extends ValueNotifier<double> {
  DoubleVs(double value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TraceableDoubleVs extends DoubleVs {
  TraceableDoubleVs(double value) : super(value);

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

/// To trace [get] or [set] statements, using [TraceableStringVs].
class StringVs extends ValueNotifier<String> {
  StringVs(String value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TraceableStringVs extends StringVs {
  TraceableStringVs(String value) : super(value);

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

/// To trace [get] or [set] statements, using [TraceableBoolVs].
class BoolVs extends ValueNotifier<bool> {
  BoolVs(bool value) : super(value);

  void toggle() => value = !value;
}

/// Used to trace [get] or [set] statements.
class TraceableBoolVs extends BoolVs {
  TraceableBoolVs(bool value) : super(value);

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

/// To trace [get] or [set] statements, using [TraceableListVs].
class ListVs<E> extends ValueNotifier<List<E>> {
  ListVs(List<E> value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TraceableListVs<E> extends ListVs<E> {
  TraceableListVs(List<E> value) : super(value);

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
/// To trace [get] or [set] statements, using [TraceableSetVs].
class SetVs<E> extends ValueNotifier<Set<E>> {
  SetVs(Set<E> value) : super(value);
}

/// Used to trace [get] or [set] statements.
class TraceableSetVs<E> extends SetVs<E> {
  TraceableSetVs(Set<E> value) : super(value);

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