import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:flutter_application_5/constants/features/home/presentation/home_page.dart';
import 'package:flutter_application_5/constants/features/calculator/presentation/calculatorpage.dart';

class AppPages {
  static final Map<String, WidgetBuilder> pages = {
    AppRoutes.homePage: (_) => const HomePage(),
    AppRoutes.calculatorpage: (_) => const CalculatorPage(),
    //AppRoutes.Notespage: (_) => const Notespage(),
  };
}
