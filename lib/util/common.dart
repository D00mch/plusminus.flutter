import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final Random rand = Random();

final listEq = ListEquality();


String enumValueToString(Object o) => describeEnum(o);

T enumValueFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == enumValueToString(v), orElse: () => null);