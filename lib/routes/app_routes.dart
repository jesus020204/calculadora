import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/info_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/info': (context) => const InfoScreen(),
};