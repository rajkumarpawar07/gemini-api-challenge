import 'package:flutter/material.dart';
import 'package:gemini_api_challenge/main.dart';

class AppRouter {
  static const String loginRoute = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Error: Unknown route')));
    }
  }
}
