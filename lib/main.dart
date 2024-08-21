import 'package:csc_4130_iot_application/Constants/BrandColors.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
import 'package:flutter/material.dart';
import 'package:csc_4130_iot_application/Screens/ChartPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        body:ChartPage(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
