import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_colors.dart';
import 'data/app_state.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const PlantifyApp()));
}

class PlantifyApp extends StatelessWidget {
  const PlantifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder wraps the whole app so any screen that
    // calls AppState.instance.notifyListeners() causes a rebuild
    // only in the widgets that actually listen — efficient.
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (_, __) => MaterialApp(
        title: 'Plantify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryDark,
              primary: AppColors.primaryDark),
          scaffoldBackgroundColor: AppColors.screenBg,
          splashFactory: InkRipple.splashFactory,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/splash',
        routes: {
          '/splash':   (_) => const SplashScreen(),
          '/login':    (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/forgot':   (_) => const ForgotPasswordScreen(),
          '/home':     (_) => const MainShell(),
        },
      ),
    );
  }
}
