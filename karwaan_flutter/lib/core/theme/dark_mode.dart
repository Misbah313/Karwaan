import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade800,
    // app theme
    colorScheme: ColorScheme.dark(
      primary: Colors.grey.shade700,
      surface: Colors.grey.shade900,
      onSurface: Colors.grey.shade600,
      secondary: Colors.blueGrey.shade800,
      onSecondary: Colors.grey.shade800,
    ),

    // text theme
    textTheme: TextTheme(
        bodyLarge: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.grey.shade300, fontSize: 25),
        displayMedium: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
            fontSize: 20),
        bodyMedium: GoogleFonts.alef(
            color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.alef(color: Colors.grey.shade400),
        titleLarge: GoogleFonts.alef(color: Colors.grey.shade400),
        titleMedium: GoogleFonts.alef(
            fontWeight: FontWeight.w600, color: Colors.grey.shade300),
        titleSmall: GoogleFonts.alef(color: Colors.grey.shade500)),

    // icon theme
    iconTheme: IconThemeData(color: Colors.grey.shade500),

    // divder theme
    dividerColor: Colors.grey.shade500,

    // dialog theme
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade700,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),

    // drawer theme
    drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade800));
