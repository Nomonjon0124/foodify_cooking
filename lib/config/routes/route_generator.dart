import 'package:flutter/material.dart';

@Deprecated('Use AppRouter.router (go_router) instead.')
abstract final class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Deprecated route generator. Use AppRouter.router.'),
        ),
      ),
    );
  }
}
