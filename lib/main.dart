import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/features/home/presentation/home_page.dart';
//import 'package:flutter_application_5/constants/features/home/presentation/test_page.dart';
import 'package:flutter_application_5/theme/dark_theme.dart';
//import 'package:hot_app/main_shell.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'OpLD Demo',
      //theme: DarkTheme().theme,
      darkTheme: DarkTheme.theme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
