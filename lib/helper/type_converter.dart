import 'package:flutter/foundation.dart';

class TypeConverter {
  static List<int> convertIntoListOfInteger(String options) {
    List<int> result = [];
    String s = options.replaceAll('(', '').replaceAll(')', '');
    List<String> res = s.split(',');
    for (String element in res) {
      try {
        result.add(int.parse(element));
      } catch (e) {
        if (kDebugMode) {
          print('=====not converted : $e');
        }
      }
    }
    return result;
  }
}
