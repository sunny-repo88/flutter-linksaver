import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkSaverTheme {
  static const Color primary = Color.fromARGB(255, 74, 20, 140);

  static ThemeData get light {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.purple[900],
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
        accentColor: const Color.fromARGB(255, 74, 20, 140),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      toggleableActiveColor: Color.fromARGB(255, 74, 20, 140),
      textTheme: TextTheme(
        headline6: TextStyle(),
      ).apply(
        bodyColor: const Color.fromARGB(255, 74, 20, 140),
        displayColor: const Color.fromARGB(255, 74, 20, 140),
      ),
      // fontFamily: GoogleFonts.poppins().fontFamily
    );
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: const Color.fromARGB(33, 33, 33, 1),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        accentColor: const Color.fromARGB(255, 74, 20, 140),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      toggleableActiveColor: Color.fromARGB(255, 74, 20, 140),
      textTheme: TextTheme(
        headline6: TextStyle(),
      ).apply(
        bodyColor: const Color.fromARGB(255, 74, 20, 140),
        displayColor: const Color.fromARGB(255, 74, 20, 140),
      ),
    );
  }
}

class LinkSaverLighTheme {
  Color color = Color(0xFF424242);
  Color boxDecorationColor = Color.fromARGB(255, 237, 243, 251);
  Color accentColor = Color.fromARGB(255, 74, 20, 140);
}

class LinkSaverDarkTheme {
  Color color = Color(0xFFFFFFFF);
  Color boxDecorationColor = Color(0xFF424242);
  Color accentColor = Color.fromARGB(255, 74, 20, 140);
}
