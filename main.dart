import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'path_defining_page.dart'; // Import your path defining page
import 'simulation_page.dart'; // Import your simulation page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Simulation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/pathDefining': (context) => UserPathPage(),
        '/simulationPage': (context) {
          // You need to pass path data when navigating to this page
          final path = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;
          return SimulationPage(path: path);
        },
      },
    );
  }
}
