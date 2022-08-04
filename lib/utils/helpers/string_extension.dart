final RegExp _wordsRegex = RegExp(r'(^\w{1})|(\s+\w{1})');

extension StringExt on String {
  String get capitalizeEachWords => replaceAllMapped(
        _wordsRegex,
        (match) => substring(match.start, match.end).toUpperCase(),
      );
}

extension NullableStringExt on String? {
  String get emptyIfNull => this ?? '';
}
