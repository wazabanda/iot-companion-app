import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/HomeScreen.dart';
import 'package:csc_4130_iot_application/Screens/SettingsScreen.dart';
import 'package:csc_4130_iot_application/Screens/SplashScreen.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart';
import 'package:csc_4130_iot_application/Providers/ThemeProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppInfo()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _bodies = [
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Mega Things Companion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        
        // Colors
        primaryColor: BrandColors.primary,
        scaffoldBackgroundColor: BrandColors.background,
        
        // AppBar theme
        appBarTheme: AppBarTheme(
          color: BrandColors.surfaceLight,
          elevation: 0,
          iconTheme: IconThemeData(color: BrandColors.baseContent),
          titleTextStyle: TextStyle(
            color: BrandColors.baseContent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Color scheme
        colorScheme: ColorScheme.light(
          primary: BrandColors.primary,
          onPrimary: BrandColors.primaryContent,
          secondary: BrandColors.secondary,
          onSecondary: BrandColors.secondaryContent,
          background: BrandColors.background,
          onBackground: BrandColors.baseContent,
          surface: BrandColors.surfaceLight,
          onSurface: BrandColors.baseContent,
          error: BrandColors.error,
          onError: BrandColors.error,
        ),
        
        // Card theme
        cardTheme: CardTheme(
          color: BrandColors.surfaceLight,
          elevation: 0,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // radius-box: 0rem
          ),
        ),
        
        // Text theme
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold
          ),
          headlineMedium: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
          bodyLarge: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 18
          ),
          bodyMedium: TextStyle(
            color: BrandColors.textPrimary,
            fontSize: 16
          ),
        ),
        
        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: BrandColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // radius-field: 1rem
            borderSide: BorderSide(
              color: BrandColors.neutral.withOpacity(0.2),
              width: 1, // border: 1px
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: BrandColors.neutral.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: BrandColors.primary,
              width: 1,
            ),
          ),
        ),
        
        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: BrandColors.primary,
            foregroundColor: BrandColors.primaryContent,
            elevation: 0, // depth: 0
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // radius-selector: 0.25rem
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4, // size-selector: 0.25rem
            ),
          ),
        ),
        
        // Bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: BrandColors.surfaceLight,
          selectedItemColor: BrandColors.primary,
          unselectedItemColor: BrandColors.neutral,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primaryColor: BrandColors.primary,
        scaffoldBackgroundColor: BrandColors.background,
        
        // Update other theme properties similarly using the dark colors
        // ... rest of the dark theme configuration
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
