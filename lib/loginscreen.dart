import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_attendance/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeigh = 0;
  double screenWidth = 0;

  Color primary = Color.fromARGB(253, 68, 176, 239);

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            isKeyboardVisible
                ? SizedBox(
                    height: screenHeight / 16,
                  )
                : Container(
                    height: screenHeight / 2.5,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(70),
                        bottomLeft: Radius.circular(70),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: screenWidth / 5,
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight / 15,
                bottom: screenHeight / 20,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: screenWidth / 18,
                  fontFamily: "NexaBold",
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth / 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "ID Karyawan",
                      style: TextStyle(
                        fontSize: screenWidth / 26,
                        fontFamily: "NexaBold",
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          )
                        ]),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth / 8,
                          child: Icon(
                            Icons.person,
                            color: primary,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth / 12),
                            child: TextFormField(
                              controller: idController,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeigh / 35,
                                ),
                                border: InputBorder.none,
                                hintText: "Masukkan id Karyawan",
                              ),
                              maxLines: 1,
                              obscureText: false,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: screenWidth / 26,
                        fontFamily: "NexaBold",
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          )
                        ]),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth / 8,
                          child: Icon(
                            Icons.key,
                            color: primary,
                            size: screenWidth / 15,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth / 12),
                            child: TextFormField(
                              controller: passController,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeigh / 35,
                                ),
                                border: InputBorder.none,
                                hintText: "Masukkan Password",
                              ),
                              maxLines: 1,
                              obscureText: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String id = idController.text.trim();
                      String password = passController.text.trim();
                      

                      if(id.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("ID Karyawan tidak boleh kosong"),
                      
                        ));
                      } else if(password.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Password tidak boleh kosong"),
                         
                        ));
                      } else {
                        QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("karyawan")
                          .where('id', isEqualTo: id)
                          .get();

                      try{
                        if(password == snap.docs[0]['password']){
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen()
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Password salah"),
                          ));
                        }
                      } catch(e) {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ID Karyawan tidak ditemukan"),
                          ));
                      }
                      }
                    },
                      child:
                      Container(
                        height: 60,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: screenWidth / 40),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 26,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obsecure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        children: [
          Container(
            width: screenWidth / 8,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeigh / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
                obscureText: obsecure,
              ),
            ),
          )
        ],
      ),
    );
  }
}
