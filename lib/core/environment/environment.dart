import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get backLinuxBaseUrl => _get('backLinuxBaseUrl');

  static String _get(String name) => dotenv.get(name);
}
