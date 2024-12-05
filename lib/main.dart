import 'package:calling_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calling App',
      theme:AppTheme.theme,
      home: HomePage(
          
      ),
    );
  }
}

