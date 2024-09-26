import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/HomeScreen.dart';
import 'package:csc_4130_iot_application/Screens/SettingsScreen.dart';
import 'package:csc_4130_iot_application/Constants/BrandColors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
// Entry Point for applicatoin, this wraps the home screen and Settings
class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _bodies = [
    HomeScreen(),
    SettingsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mega Things Companion App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: BrandColors.oxfordBlue,
        scaffoldBackgroundColor: BrandColors.oxfordBlue,
        appBarTheme: AppBarTheme(
          color: BrandColors.oxfordBlue,
          iconTheme: IconThemeData(color: BrandColors.white),
          titleTextStyle: TextStyle(color: BrandColors.white, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: BrandColors.oxfordBlue,
          primary: BrandColors.oxfordBlue,
          secondary: BrandColors.carrotOrange,
          background: BrandColors.oxfordBlue,
          surface: BrandColors.antiFlashWhite,
          onPrimary: BrandColors.white,
          onSecondary: BrandColors.oxfordBlue,
          onBackground: BrandColors.white,
          onSurface: BrandColors.oxfordBlue,
        ),
        cardTheme: CardTheme(
          color: BrandColors.carrotOrange,
          elevation: 4,
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: BrandColors.white, fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: BrandColors.white, fontSize: 28, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: BrandColors.white, fontSize: 18),
          bodyMedium: TextStyle(color: BrandColors.white, fontSize: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: BrandColors.carrotOrange,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(color: BrandColors.white),
        dividerColor: BrandColors.antiFlashWhite,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: BrandColors.oxfordBlue,
          selectedItemColor: BrandColors.carrotOrange,
          unselectedItemColor: BrandColors.white.withOpacity(0.6),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: BrandColors.oxfordBlue,
          title: Text("Mega Things Companion App",
            style: TextStyle(color: BrandColors.white),
            textAlign: TextAlign.center,),
        ),
        body: _bodies[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
