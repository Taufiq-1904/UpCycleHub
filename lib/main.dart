import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/themes/app_theme.dart';
import 'app/services/storage_service.dart';
import 'app/services/auth_service.dart';
import 'app/config/app_config.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env pertama, sebelum apapun
  await dotenv.load(fileName: '.env');

  await initializeDateFormatting('id_ID', null);

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init Services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AuthService().init());

  // Debug — hapus saat production
  if (AppConfig.isDevelopment) {
    debugPrint('🌐 Auth URL   : ${AppConfig.authBaseUrl}');
    debugPrint('🌐 Product URL: ${AppConfig.productBaseUrl}');
    debugPrint('🔧 Env        : ${AppConfig.appEnv}');
  }

  runApp(const UpCycleHubApp());
}

class UpCycleHubApp extends StatelessWidget {
  const UpCycleHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
