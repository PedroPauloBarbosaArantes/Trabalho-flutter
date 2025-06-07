import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_list/view_models/crypto_list_view_model.dart';
import 'package:crypto_list/views/crypto_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CryptoListViewModel())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crypto Tracker',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Color(0xFF1A1A2E),
          cardTheme: CardThemeData(
            color: Color(0xFF16213E),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0F3460),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE94560),
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF16213E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFFE94560), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFFE94560), width: 3),
            ),
            labelStyle: TextStyle(color: Colors.white70),
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        home: CryptoListScreen(),
      ),
    );
  }
} 