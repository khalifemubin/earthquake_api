import 'package:flutter/material.dart';
import './ui/quake.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Quake Info",
    home: new Quake(),
  ));
}
