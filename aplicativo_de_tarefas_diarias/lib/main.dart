import 'package:flutter/material.dart';
import 'screens/todos_screen.dart'; // Ajuste para o seu caminho

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  ThemeData get currentTheme {
    return isDarkTheme
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.grey[850],
            appBarTheme: AppBarTheme(color: Colors.deepOrange),
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.deepOrange),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.black), // Alterado
              bodyMedium: TextStyle(color: Colors.black), // Alterado
            ),
          );
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: currentTheme,
      home: Todos_screen(onToggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
    );
  }
}
