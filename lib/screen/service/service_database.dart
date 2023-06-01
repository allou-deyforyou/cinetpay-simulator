import 'package:flutter/foundation.dart';

class DatabaseService extends ValueNotifier<bool> {
  DatabaseService() : super(false);

  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService();
}
