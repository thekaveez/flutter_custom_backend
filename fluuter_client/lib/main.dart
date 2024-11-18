import 'package:flutter/material.dart';
import 'package:fluuter_client/pages/home_page.dart';
import 'package:fluuter_client/providers/driver_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(providers:
      [
        ChangeNotifierProvider(create: (_) => DriverProvider()),
      ],
          child: const MyApp()
      )
      );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomePage(),
    );
  }
}