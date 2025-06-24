import 'package:game/socket_servise.dart';
import 'package:game/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketServise().conectToServer();
  runApp(const BusCompleteApp());
}

class BusCompleteApp extends StatelessWidget {
  const BusCompleteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bus complete',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
