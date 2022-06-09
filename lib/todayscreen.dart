import 'package:flutter/material.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child : Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "nexaRegular",
                  fontSize: screenWidth / 20,
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}
