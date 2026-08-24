import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/features/home/presentation/home_page.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';
import 'package:flutter_application_5/theme/dark_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OpLdService.instance.initialize();
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
