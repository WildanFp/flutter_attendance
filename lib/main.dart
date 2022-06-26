import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/homescreen.dart';
import 'package:flutter_attendance/loginscreen.dart';
import 'package:flutter_attendance/model/user.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
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
      home: KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();

  Future signOut() async {
    try {
      return auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<bool> logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final id = storage.getString('Idkaryawan');
    if (id != null) {
      await storage.remove('Idkaryawan');
      return true;
    } else {
      return false;
    }
  }
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = true;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (userAvailable == false) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('Idkaryawan') != null) {
        setState(() {
          User1.idkaryawan = sharedPreferences.getString('Idkaryawan')!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const LoginScreen() : const LoginScreen();
  }
}
