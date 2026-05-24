import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get authBaseUrl => dotenv.env['AUTH_BASE_URL']!;

  static String get productBaseUrl => dotenv.env['PRODUCT_BASE_URL']!;

  static String get authApiUrl => '$authBaseUrl/auth';

  static String get appName => dotenv.env['APP_NAME']!;

  static String get appEnv => dotenv.env['APP_ENV']!;

  static bool get isProduction => appEnv == 'production';
  static bool get isDevelopment => appEnv == 'development';

  static int get connectTimeout => int.parse(dotenv.env['CONNECT_TIMEOUT']!);

  static int get receiveTimeout => int.parse(dotenv.env['RECEIVE_TIMEOUT']!);
}
