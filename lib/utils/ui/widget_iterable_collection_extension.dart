extension WidgetIterableCollectionExtension<Widget> on Iterable<Widget> {
  Iterable<Widget> separateWith([Widget? widget]) sync* {
    if (widget == null) {
      yield* this;
      return;
    }

    final int len = length;

    if (len == 1) {
      yield* this;
      return;
    }

    int count = 0;
    final Iterator<Widget> it = iterator;
    while (it.moveNext()) {
      count++;
      yield it.current;
      if (count != len) yield widget;
    }
  }

  /// Adds one or more widgets to the beginning.
  ///
  /// ```dart
  /// List<Widget> arr = [ D(), E(), F() ];
  ///
  /// print(
  ///   arr.unshift(widget: A() )
  /// ); // [ A(), D(), E(), F() ]
  ///
  /// print(
  ///   arr.unshift(widgets: [ A(), B(), C() ])
  /// ); // [ A(), B(), C(), D(), E(), F() ]
  ///
  /// print(
  ///   arr.unshift(
  ///     widget: S(),
  ///     widgets: [ A(), B(), C() ]
  ///   )
  /// ); // [ S(), A(), B(), C(), D(), E(), F() ]
  /// ```
  Iterable<Widget> unshift({
    Widget? widget,
    List<Widget> widgets = const [],
  }) sync* {
    if (widget != null) yield widget;

    if (widgets.isNotEmpty) yield* widgets;

    yield* this;
  }
}
