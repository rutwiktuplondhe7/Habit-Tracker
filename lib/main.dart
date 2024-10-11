import 'package:flutter/material.dart';
import 'package:habbit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize the database;
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(
      providers: [
        //habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),

        //theme Provider
        ChangeNotifierProvider(create: (context) => ThemePovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemePovider>(context).themeData,
    );
  }
}
