import 'package:csc_4130_iot_application/Constants/BrandColors.dart';
import 'package:csc_4130_iot_application/Providers/GlobalProvider.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
import 'package:csc_4130_iot_application/Screens/HomeScreen.dart';
import 'package:csc_4130_iot_application/Screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';

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

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _bodies = [
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        useMaterial3: true,

      ),

      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Brandcolors.primary1,
          title: Text("Mega Things Companion App",
            style: TextStyle(color: Brandcolors.textPrimay),
            textAlign: TextAlign.center,),
        ),
        body:_bodies[_currentIndex],
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
              label: 'Settings'
            ),

          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
