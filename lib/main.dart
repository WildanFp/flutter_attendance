import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/homescreen.dart';
import 'package:flutter_attendance/loginscreen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardVisibilityProvider(child: AuthCheck()),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({ Key? key }) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
 bool userAvailable = false;
 late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
  }

  void _getUser() async {
    try{
      if(sharedPreferences.getString('id karyawan') != null){
        setState(() {
          userAvailable = true;
        });
      }
    } catch(e){
      setState(() {
          userAvailable = false;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? HomeScreen() : LoginScreen();
  }
}
