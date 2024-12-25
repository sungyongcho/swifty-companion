import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swifty_companion/pages/login_page.dart';
import 'package:swifty_companion/pages/profile_page.dart';

void main() async {
  await dotenv.load(); // Load .env file
  runApp(SwiftyCompanionApp());
}

class SwiftyCompanionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
