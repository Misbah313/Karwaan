import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade300,
    // app theme
    colorScheme: ColorScheme.light(
      primary: Color(0xFFD6D6D6),
      secondary: Colors.blueGrey.shade300,
      onSecondary: Colors.grey.shade300,
      surface: Colors.grey.shade400,
      onSurface: Colors.grey.shade300,
    ),

    // text theme
    textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            fontSize: 25),
            displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey.shade500, fontSize: 20),
        bodyMedium: GoogleFonts.alef(
            color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.alef(color: Colors.grey.shade600),
        titleLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.grey),
        titleMedium: GoogleFonts.alef(
            fontWeight: FontWeight.w600, color: Colors.grey.shade600),
        titleSmall: GoogleFonts.alef(color: Colors.grey)),

    // icon themes
    iconTheme: IconThemeData(color: Colors.grey.shade500),

    // divider theme
    dividerColor: Colors.grey.shade500,

    // dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade300,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade300),

    // drawer theme
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.grey.shade300,
    ));
