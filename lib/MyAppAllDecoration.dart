import 'package:flutter/material.dart';
import 'package:jagapegawai/HomeScreen.dart';
import 'package:jagapegawai/Style.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorDarkBlue,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: ColorWhite),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: ColorWhite,
          filled: true,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorGreen),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorWhite),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ColorGreen),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorRed),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorWhite),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorGreen,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorGreen,
            textStyle: const TextStyle(fontSize: 16, color: ColorWhite),
          ),
        ),
      ),
    );
  }
}
