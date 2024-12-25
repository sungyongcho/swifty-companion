import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swifty_companion/pages/login_page.dart';
import 'package:swifty_companion/pages/profile_page.dart';
import 'package:swifty_companion/services/oauth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load .env file

  final OAuthService authService = OAuthService();
  final token = await authService.getToken();
  runApp(SwiftyCompanionApp(
      authService: authService,
      initialRoute: token != null ? '/profile' : '/'));
}

class SwiftyCompanionApp extends StatelessWidget {
  final OAuthService authService;
  final String initialRoute;

  SwiftyCompanionApp({required this.authService, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginPage(authService: authService),
        '/profile': (context) => ProfilePage(authService: authService),
      },
    );
  }
}
