import 'package:flutter/material.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({ Key? key }) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Text("Today"),
      ),
      
    );
  }
}