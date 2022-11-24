extension WidgetIterableCollectionExtension<Widget> on Iterable<Widget> {
  Iterable<Widget> separateWith(Widget widget) sync* {
    final int len = length;
    int count = 0;
    final Iterator<Widget> it = iterator;
    while (it.moveNext()) {
      count++;
      yield it.current;
      if (count != len) yield widget;
    }
  }
}
