import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApiConstants {
  static String baseUrl = 'https://jsonplaceholder.typicode.com';
  static String usersEndpoint = '/users';
}

class ThemeConstants {
  static InputDecoration searchFieldDecoration = InputDecoration(
    hintStyle: GoogleFonts.roboto(),
    hintText: 'Search Robots',
    fillColor: Colors.white,
    filled: true,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        style: BorderStyle.solid,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        style: BorderStyle.solid,
      ),
    ),
  );
}
