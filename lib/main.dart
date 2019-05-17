import 'package:flutter/material.dart';
import './home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
@override
Widget build(context) {
return MaterialApp(
title: 'Image Puzzle',
home: HomeScreen(),
);
}
}
