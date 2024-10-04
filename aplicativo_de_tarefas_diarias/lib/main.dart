import 'package:aplicativo_de_tarefas_diarias/screens/creating_todo_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicativo de tarefas diarias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Creating_todo_screen(),
    );
  }
}
