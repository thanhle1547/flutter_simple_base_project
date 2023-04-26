/// Example:
///
/// ```dart
/// const Map<String, dynamic> json = {
///   "a": "1",
///   "b": [
///     {},
///     { "c": "2" }
///   ],
///   "d": "2022-10-01 10:15:07.922"
/// };
///
/// print(json.pick<String>(['b', 0, 'c']));  // null
/// print(json.pick<String>(['b', 1, 'c']));  // 2
///
/// print(json.query<String>('b.#0.c'));      // null
/// print(json.query<String>('b.#1.c'));      // 2
///
/// print(json.lookup<String>('a'));          // 1
///
/// print(json.getAndApply<int, String>('aa', converter: int.parse));   // null
/// print(json.getAndApplyWhen<String, int>(
///   'a', converter: (int value) => value.toString()
/// )); // 1
///
/// print(json.lookupAndApply<int, String>('a', converter: int.parse)); // 1
///
/// // Key value aaa is missing from list, add it using [defaultValue].
/// print(json.lookupAndApply<int, String>(
///   'aaa', defaultValue: 10, converter: int.parse
/// )); // 10
///
/// import 'package:intl/intl.dart';
///
/// print(json.lookupAndApply2<String, String, DateTime>(
///   'd',
///   converter1: DateTime.parse,
///   converter2: DateFormat('dd/MM/yyyy').format
/// )); // 01/10/2022print(json.getAndApply2<String, String, DateTime>(
///   'dd',
///   converter1: DateTime.parse,
///   converter2: DateFormat('dd/MM/yyyy').format
/// )); // null
/// ```
extension JsonExt on Map<String, dynamic> {
  /// Extract required value from specific keys or index of nested List
  /// inside Map. (Like [g_json](https://pub.dev/packages/g_json) package).
  ///
  /// If the key is present, its type is not [R], throw an exception.
  ///
  /// Support optional key by using `?` character/operator.
  ///
  /// Support getting an item in a List by giving the item index.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": 1,
  ///   "b": [
  ///     { "c": "2" },
  ///     { "d": 3   }
  ///   ]
  /// };
  ///
  /// print(json.pick<int>(['b', 0, 'd'])); // null
  /// print(json.pick<int>(['b', 1, 'd'])); // 3
  /// ```
  R? pick<R>(List keys) {
    final value = _pick(keys);

    return value;
  }

  R? _pick<R>(List keys) {
    bool foundOptionalValue = false;
    final value = keys.fold<dynamic>(this, (source, target) {
      if (source is Map) {
        foundOptionalValue = target is String && target.endsWith('?');

        final effectiveTarget = foundOptionalValue
            ? target.substring(0, target.length - 1)
            : target;

        if (keys.last == target) {
          foundOptionalValue = true;
        }

        return source.lookup(effectiveTarget, foundOptionalValue);
      }

      if (source is List) {
        foundOptionalValue = false;

        final int index;
        if (target is String) {
          assert(target.startsWith('#'));

          index = int.parse(target.substring(1));
        } else {
          index = target;
        }

        assert(index < source.length);

        return source[index];
      }

      if (source == null && foundOptionalValue) {
        return null;
      }

      throw FormatException(
        "Mismatch for \"$target\": found \"${source.runtimeType}\"",
      );
    });

    if (value == null) {
      return null;
    }

    if (value is! R) {
      _valueTypeIsMismatch<R>(keys.last, value);
    }

    return value;
  }

  /// Extract required value from specific keys or index of nested List
  /// inside Map.
  ///
  /// If the value (picking result) is not present, call [ifAbsent] to get a
  /// computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the value (picking result) is present, invoke [converter] with
  /// the current value if it is provided.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": {
  ///     "c": "2",
  ///     "d": {
  ///       "e": "3"
  ///     }
  ///   }
  /// };
  ///
  /// print(json.pickAndApply<int, String>(
  ///   ['a', 'b', 'd', 'e'],
  ///   converter: int.parse,
  /// )); // 3
  ///
  /// // Key value ff is missing from list, add it return null.
  /// print(json.pickAndApply<int, String>(
  ///   ['a', 'b', 'd', 'ff'],
  ///   converter: int.parse,
  /// )); // null
  ///
  /// // Key value gg is missing from list, add it return null.
  /// print(json.pickAndApply<int, String>(
  ///   ['a', 'b', 'd', 'ff?', 'gg'],
  ///   converter: int.parse
  /// )); // null
  ///
  /// // Key value ff is missing from list, add it using [ifAbsent].
  /// print(json.pickAndApply<int, String>(
  ///   ['aa'],
  ///   ifAbsent: () => '10',
  ///   converter: int.parse,
  /// )); // 10
  /// ```
  /// See also:
  ///   * [pick]
  R? pickAndApply<R, V>(
    List keys, {
    V Function()? ifAbsent,
    required R Function(V value) converter,
  }) {
    final value = _pick(keys) ?? ifAbsent?.call();
    if (value == null) {
      return null;
    }

    return converter(value);
  }

  /// Extract required value from specific keys or index of nested List
  /// inside Map.
  ///
  /// If the value (picking result) is not present, call [ifAbsent] to get a
  /// computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the value (picking result) is present, invokes [converter1] with
  /// the current value, then invokes [converter2] with the value returns
  /// from [converter1]. The new value returns from [converter2] if not null
  /// is returned.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": {
  ///     time": "2022-10-01 10:15:07.922"
  ///   }
  /// };
  ///
  /// print(json.getAndApply2<String, String, DateTime>(
  ///   ['a', 'b', 'time'],
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // 01/10/2022
  ///
  /// // Key value datetime is missing from list, add it return null.
  /// print(json.getAndApply2<String, String, DateTime>(
  ///   ['a', 'b', 'datetime'],
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // null
  /// ```
  /// See also:
  ///   * [pick]
  R? pickAndApply2<R, V, CR>(
    List keys, {
    V Function()? ifAbsent,
    required CR Function(V value) converter1,
    required R Function(CR value) converter2,
  }) {
    final value = _pick(keys) ?? ifAbsent?.call();
    if (value == null) {
      return null;
    }

    return converter2(converter1(value));
  }

  /// Extract required value from specific paths like
  /// [path_selector](https://pub.dev/packages/path_selector) package.
  ///
  /// Each key is separated by dot character/operator.
  ///
  /// Support optional chaining.
  ///
  /// Support getting an item in a List by using `#` with the item index.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": 1,
  ///   "b": [
  ///     { "c": "2" },
  ///     { "d": 3   }
  ///   ]
  /// };
  ///
  /// print(json.query<int>('b.#1.d')); // 3
  /// ```
  R? query<R>(String keys) => pick<R>(keys.split('.'));

  /// Extract required value from specific keys or index of nested List
  /// inside Map.
  ///
  /// If the value (picking result) is not present, call [ifAbsent] to get a
  /// computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the value (picking result) is present, invoke [converter] with
  /// the current value if it is provided.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": {
  ///     "c": "2",
  ///     "d": {
  ///       "e": "3"
  ///     }
  ///   }
  /// };
  ///
  /// print(json.queryAndApply<int, String>(
  ///   'a.b.d.e',
  ///   converter: int.parse,
  /// )); // 3
  ///
  /// // Key value ff is missing from list, add it return null.
  /// print(json.queryAndApply<int, String>(
  ///   'a.b.d.ff',
  ///   converter: int.parse,
  /// )); // null
  ///
  /// // Key value gg is missing from list, add it return null.
  /// print(json.queryAndApply<int, String>(
  ///   'a.b.d.ff?.gg',
  ///   converter: int.parse
  /// )); // null
  ///
  /// // Key value ff is missing from list, add it using [ifAbsent].
  /// print(json.queryAndApply<int, String>(
  ///   'aa',
  ///   ifAbsent: () => '10',
  ///   converter: int.parse,
  /// )); // 10
  /// ```
  /// See also:
  ///   * [query]
  R? queryAndApply<R, V>(
    String keys, {
    V Function()? ifAbsent,
    required R Function(V) converter,
  }) =>
      pickAndApply<R, V>(
        keys.split('.'),
        ifAbsent: ifAbsent,
        converter: converter,
      );

  /// Extract required value from specific keys or index of nested List
  /// inside Map.
  ///
  /// If the value (picking result) is not present, call [ifAbsent] to get a
  /// computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the value (picking result) is present, invokes [converter1] with
  /// the current value, then invokes [converter2] with the value returns
  /// from [converter1]. The new value returns from [converter2] if not null
  /// is returned.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": {
  ///     time": "2022-10-01 10:15:07.922"
  ///   }
  /// };
  ///
  /// print(json.queryAndApply2<String, String, DateTime>(
  ///   'a.b.time',
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // 01/10/2022
  ///
  /// // Key value datetime is missing from list, add it return null.
  /// print(json.queryAndApply2<String, String, DateTime>(
  ///   'a.b.datetime',
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // null
  /// ```
  /// See also:
  ///   * [query]
  R? queryAndApply2<R, V, CR>(
    String keys, {
    V Function()? ifAbsent,
    required CR Function(V value) converter1,
    required R Function(CR value) converter2,
  }) =>
      pickAndApply2<R, V, CR>(
        keys.split('.'),
        ifAbsent: ifAbsent,
        converter1: converter1,
        converter2: converter2,
      );

  /// Look up the value of [key], or return [defaultValue] if it isn't there.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": "2"
  /// };
  ///
  /// print(json.lookup<String>('a'));  // 1
  /// ```
  R lookup<R>(
    String key, {
    R? defaultValue,
  }) {
    final value = this[key];
    if (value == null) {
      if (defaultValue != null) {
        return defaultValue;
      }

      _valueIsNull<R>(key);
    }

    if (value is! R) {
      _valueTypeIsMismatch<R>(key, value);
    }

    return value;
  }

  /// Look up the value of [key] with type [V], or call [ifAbsent] if it isn't
  /// there to get a computed/alter value. Otherwise, return null if it is not
  /// provided.
  ///
  /// If the key is present, invoke [converter] with the current value if it
  /// is provided.
  ///
  /// If the key is not present, [ifAbsent] is not provided and [defaultValue]
  /// is provided, returns [defaultValue].
  ///
  /// If the key is not present, [ifAbsent] is not provided, and [defaultValue]
  /// is not provided, throw an exception.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": "2"
  /// };
  ///
  /// print(json.lookupAndApply<int, String>('a', converter: int.parse)); // 1
  ///
  /// // Key value aaa is missing from list, add it using [defaultValue].
  /// print(json.lookupAndApply<int, String>(
  ///   'aaa', defaultValue: 10, converter: int.parse
  /// )); // 10
  /// ```
  R lookupAndApply<R extends Object, V>(
    String key, {
    R? defaultValue,
    V Function()? ifAbsent,
    required R Function(V value) converter,
  }) {
    final value = this[key] ?? ifAbsent?.call();
    if (value == null) {
      if (defaultValue != null) {
        return defaultValue;
      }

      _valueIsNull<R>(key);
    }

    return converter(value);
  }

  /// Look up the value of [key] with type [V], or call [ifAbsent] if it isn't
  /// there to get a computed/alter value. Otherwise, return [defaultValue]
  /// if it is provided.
  ///
  /// If the key is present, invokes [converter1] with the current value,
  /// then invokes [converter2] with the value returns from [converter1].
  /// The new value returns from [converter2] if not null is returned.
  ///
  /// If the key is not present, [ifAbsent] is not provided and [defaultValue]
  /// is provided, returns [defaultValue].
  ///
  /// If the key is not present, [ifAbsent] is not provided, and [defaultValue]
  /// is not provided, throw an exception.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "time": "2022-10-01 10:15:07.922"
  /// };
  ///
  /// print(json.lookupAndApply2<String, String, DateTime>(
  ///   'time',
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // 01/10/2022
  /// ```
  R lookupAndApply2<R extends Object, V extends Object, CR>(
    String key, {
    R? defaultValue,
    V Function()? ifAbsent,
    required CR Function(V value) converter1,
    required R Function(CR value) converter2,
  }) {
    final value = this[key] ?? ifAbsent?.call();

    if (value == null) {
      if (defaultValue != null) {
        return defaultValue;
      }

      _valueIsNull<R>(key);
    }

    assert(value is V);

    return converter2(converter1(value));
  }

  /// Get the value of [key], or call [ifAbsent] if it isn't there to get
  /// a computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the key is present, invoke [converter] with the current value if it
  /// is provided.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": "1",
  ///   "b": "2"
  /// };
  ///
  /// print(json.getAndApply<int, String>('a', converter: int.parse)); // 1
  ///
  /// // Key value aa is missing from list, add it return null.
  /// print(json.getAndApply<int, String>('aa', converter: int.parse)); // null
  ///
  /// // Key value aa is missing from list, add it using [ifAbsent].
  /// print(json.getAndApply<int, String>(
  ///   'aa',
  ///   ifAbsent: () => '10',
  ///   converter: int.parse,
  /// )); // 10
  /// ```
  R? getAndApply<R, V>(
    String key, {
    V Function()? ifAbsent,
    R Function(V value)? converter,
  }) {
    final value = this[key] ?? ifAbsent?.call();
    if (value == null) {
      return null;
    }

    if (converter != null) {
      return converter(value);
    }

    return value;
  }

  /// Get the value of [key], or return null if it is not provided.
  ///
  /// If the key is present, its type is not [R], invokes [converter] if it is
  /// provided with the current value.
  ///
  /// If the key is present, its type is not [R], and [converter] is not
  /// provided, throw an exception.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "a": 1,
  ///   "b": 2
  /// };
  ///
  /// print(json.getAndApplyWhen<String, int>(
  ///   'a', converter: (int value) => value.toString()
  /// )); // 1
  /// ```
  R? getAndApplyWhen<R, V>(
    String key, {
    R Function(V value)? converter,
  }) {
    final value = this[key];
    if (value == null) {
      return null;
    }

    if (value is! R) {
      if (converter != null) {
        return converter(value);
      }

      _valueTypeIsMismatch<R>(key, value);
    }

    return value;
  }

  /// Get the value of [key], or call [ifAbsent] if it isn't there to get a
  /// computed/alter value. Otherwise, return null if it is not provided.
  ///
  /// If the key is present, invokes [converter1] with the current value,
  /// then invokes [converter2] with the value returns from [converter1].
  /// The new value returns from [converter2] if not null is returned.
  ///
  /// Example:
  ///
  /// ```dart
  /// const Map<String, dynamic> json = {
  ///   "time": "2022-10-01 10:15:07.922"
  /// };
  ///
  /// print(json.getAndApply2<String, String, DateTime>(
  ///   'time',
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // 01/10/2022
  ///
  /// // Key value datetime is missing from list, add it return null.
  /// print(json.getAndApply2<String, String, DateTime>(
  ///   'datetime',
  ///   converter1: DateTime.parse,
  ///   converter2: DateFormat('dd/MM/yyyy').format
  /// )); // null
  /// ```
  R? getAndApply2<R, V, CR>(
    String key, {
    V Function()? ifAbsent,
    required CR Function(V value) converter1,
    required R Function(CR value) converter2,
  }) {
    final value = this[key] ?? ifAbsent?.call();
    if (value == null) {
      return null;
    }

    return converter2(converter1(value));
  }
}

extension on Map {
  R? lookup<R extends Object?>(String key, bool nullable) {
    final value = this[key];
    if (value == null) {
      if (nullable) return null;

      _valueIsNull<R>(key);
    }

    if (value is! R) {
      _valueTypeIsMismatch<R>(key, value);
    }

    return value;
  }
}

Never _valueIsNull<R>(key) => _valueTypeIsMismatch<R>(key, null);

Never _valueTypeIsMismatch<R>(key, current) {
  throw FormatException(
    "Mismatch for \"$key\": expected '$R', found '${current.runtimeType}'",
  );
}
