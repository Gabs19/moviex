import 'package:flutter/material.dart';
import 'package:moviex/pages/home.dart';

class MoviexApp extends StatelessWidget{
  const MoviexApp({Key? key}) : super(key: key) ;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Moviex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}