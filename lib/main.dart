import 'package:flutter/material.dart';
import 'package:mapbox/src/pages/fullscreenmap.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapbox',
      home: FullScreenMap(),
    );
  }
}