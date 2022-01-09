import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// I had a problem with Sqlite so I used Hive as an alternative
class HiveHelper {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('notes');
  }

  static String get(int index) => _box.getAt(index);

  static Future<void> insert(String data) async {
    _box.add(data).then((value) {
      debugPrint('DB => Add $data success!');
    }).catchError((error) {
      debugPrint('DB => Add $data failed: $error');
    });
  }

  static void edit(int index, String data) {
    _box.putAt(index, data).then((value) {
      debugPrint('DB => Edit $data at $index success!');
    }).catchError((error) {
      debugPrint('DB => Edit $data at $index failed: $error');
    });
  }

  static void delete(int index) async {
    debugPrint('Deleting index #$index from DB');
    _box.deleteAt(index);
  }

  static int count() => _box.length;
}
