import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for SystemChrome
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set edge-to-edge mode and transparent system bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextData', // This is for OS/system use only
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Completely remove default app bar styling
        appBarTheme: const AppBarTheme(
          elevation: 0,
          toolbarHeight: 0, // Set height to 0
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
        ),
        // Optional: customize other aspects
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
      // Remove any default route transitions that might add bars
      builder: (context, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: null, // Explicitly remove app bar
          body: child,
        );
      },
    );
  }
}
