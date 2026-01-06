import 'package:karwaan_server/src/birthday_reminder.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

import 'package:karwaan_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  print('🚀 Starting Serverpod initialization...');

  // ✅ Add the Google Sign-In route
  pod.webServer.addRoute(auth.RouteGoogleSignIn(), '/googlesignin');

  // Setup web routes
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  // Start the server.
  await pod.start();

  // Register future calls
  pod.registerFutureCall(
    BirthdayReminder(),
    'birthdayReminder',
  );

  await pod.futureCallWithDelay(
    'birthdayReminder',
    Greeting(
      message: 'Hello!',
      author: 'Serverpod Server',
      timestamp: DateTime.now(),
    ),
    Duration(seconds: 5),
  );
}
