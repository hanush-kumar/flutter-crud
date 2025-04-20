import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './providers/product_provider.dart';
import './screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider()..fetchProducts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Manager',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1B1B2F),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
          ),
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
