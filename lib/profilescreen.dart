import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_attendance/loginscreen.dart';
import 'package:flutter_attendance/main.dart';
import 'model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Color.fromARGB(253, 68, 176, 239);
  String birth = "Date of birth";
  final user = FirebaseAuth.instance.currentUser;
  final AuthCheck _auth = AuthCheck();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void pickUploadProfilePic() async {

    Reference ref = FirebaseStorage.instance
        .ref();


    ref.getDownloadURL().then((value) async {
      setState(() {
      });
      await FirebaseFirestore.instance
          .collection("karyawan")
          .doc(User1.id)
          .update({
      });
    });
  }

   late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context){
      screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: primary,
                ),
                child: const Center(
                      child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Karyawan ${User1.idkaryawan}",
                style: const TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            User1.canEdit
                ? textField("First Name", "First Name", firstNameController)
                : field("First Name", User1.firstName),
            User1.canEdit
                ? textField("Last Name", "Last Name", lastNameController)
                : field("Last Name", User1.lastName),
            User1.canEdit
                ? GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primary,
                                secondary: primary,
                                onSecondary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: primary,
                                ),
                              ),
                              textTheme: const TextTheme(
                                headline4: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                overline: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                button: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((value) {
                        setState(() {
                          birth = DateFormat("MM/dd/yyyy").format(value!);
                        });
                      });
                    },
                    child: field("Date of Birth", birth),
                  )
                : field("Date of Birth", User1.birthDate),
            User1.canEdit
                ? textField("Address", "Address", addressController)
                : field("Address", User1.address),
            User1.canEdit
                ? GestureDetector(
                    onTap: () async {
                      String firstName = firstNameController.text;
                      String lastName = lastNameController.text;
                      String birthDate = birth;
                      String address = addressController.text;

                      if (User1.canEdit) {
                        if (firstName.isEmpty) {
                          showSnackBar("Please enter your first name!");
                        } else if (lastName.isEmpty) {
                          showSnackBar("Please enter your last name!");
                        } else if (birthDate.isEmpty) {
                          showSnackBar("Please enter your birth date!");
                        } else if (address.isEmpty) {
                          showSnackBar("Please enter your address!");
                        } else {
                          await FirebaseFirestore.instance
                              .collection("karyawan")
                              .doc(User1.id)
                              .update({
                            'firstName': firstName,
                            'lastName': lastName,
                            'birthDate': birthDate,
                            'address': address,
                            'canEdit': false,
                          }).then((value) {
                            setState(() {
                              User1.canEdit = false;
                              User1.firstName = firstName;
                              User1.lastName = lastName;
                              User1.birthDate = birthDate;
                              User1.address = address;
                            });
                          });
                        }
                      } else {
                        showSnackBar(
                            "You can't edit anymore, please contact support team.");
                      }
                    },
                    child: Container(
                      height: kToolbarHeight,
                      width: screenWidth,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: primary,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NexaBold",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ):
                  Container(
                    child : GestureDetector(
                    onTap: () async {
                      await _auth.signOut();
                      Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                    },
                    child: Container(
                      height: 20,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "LOGOUT",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NexaBold",
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),  
             const SizedBox(),
          ],
        ),
      ),
      );}

  Widget field(String title, String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: "NexaBold",
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black54),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(
      String tittle, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            tittle,
            style:
                const TextStyle(fontFamily: "NexaBold", color: Colors.black87),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 1,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }

 signOut() async {
    
}
}
class LogOut extends StatelessWidget {
    @override
    Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            return LoginScreen();
          }
      )
    );}