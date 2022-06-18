import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance/model/user.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeigh = 0;
  double screenWidth = 0;

  String checkin = "--/--";
  String checkout = "--/--";
  String location = " ";

  Color primary = Color.fromARGB(253, 68, 176, 239);

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(User.lat, User.long);

    setState(() {
      location =
          "${placemark[0].street}, ${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    });
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("karyawan")
          .where("id", isEqualTo: User.idkaryawan)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("karyawan")
          .doc(snap.docs[0].id)
          .collection("record")
          .doc(DateFormat('dd MMM yyy').format(DateTime.now()))
          .get();

      setState(() {
        checkin = snap2['checkin'];
        checkout = snap2['checkout'];
      });
    } catch (e) {
      setState(() {
        checkin = "--/--";
        checkout = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth / 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Employee " + User.idkaryawan,
                style: TextStyle(
                  fontFamily: "NexaRegular",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                "Today's Status",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Check In",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                            )),
                        Text(
                          checkin,
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                            fontFamily: "NexaRegular",
                            fontSize: screenWidth / 20,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          checkout,
                          style: TextStyle(
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  text: DateTime.now().day.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: screenWidth / 18,
                    fontFamily: "NexaBold",
                  ),
                  children: [
                    TextSpan(
                      text: DateFormat(' MMM yyy').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaBold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }),
            checkout == "--/--"
                ? Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 12),
                    child: Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> key = GlobalKey();
                        return SlideAction(
                          text: checkin == "--/--"
                              ? "slide to checkin"
                              : "slide to checkout",
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth / 20,
                            fontFamily: "NexaRegular",
                          ),
                          outerColor: Colors.white,
                          innerColor: primary,
                          key: key,
                          onSubmit: () async {
                            if (User.lat != 0) {
                              _getLocation();
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("karyawan")
                                  .where("id", isEqualTo: User.idkaryawan)
                                  .get();

                              DocumentSnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection("karyawan")
                                  .doc(snap.docs[0].id)
                                  .collection("record")
                                  .doc(DateFormat('dd MMM yyy')
                                      .format(DateTime.now()))
                                  .get();

                              try {
                                String checkin = snap2['checkin'];
                                setState(() {
                                  checkout = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("karyawan")
                                    .doc(snap.docs[0].id)
                                    .collection("record")
                                    .doc(DateFormat('dd MMM yyy')
                                        .format(DateTime.now()))
                                    .update({
                                  'date': Timestamp.now(),
                                  'checkin': checkin,
                                  'checkout': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  'location': location,
                                });
                              } catch (e) {
                                setState(() {
                                  checkin = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("karyawan")
                                    .doc(snap.docs[0].id)
                                    .collection("record")
                                    .doc(DateFormat('dd MMM yyy')
                                        .format(DateTime.now()))
                                    .set({
                                  'date': Timestamp.now(),
                                  'checkin': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  'checkout': "--/--",
                                  'location': location,
                                });
                              }

                              key.currentState!.reset();
                            } else {
                              Timer(const Duration(seconds: 3), () async {
                                _getLocation();
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("karyawan")
                                    .where("id", isEqualTo: User.idkaryawan)
                                    .get();

                                DocumentSnapshot snap2 = await FirebaseFirestore
                                    .instance
                                    .collection("karyawan")
                                    .doc(snap.docs[0].id)
                                    .collection("record")
                                    .doc(DateFormat('dd MMM yyy')
                                        .format(DateTime.now()))
                                    .get();

                                try {
                                  String checkin = snap2['checkin'];
                                  setState(() {
                                    checkout = DateFormat('hh:mm')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("karyawan")
                                      .doc(snap.docs[0].id)
                                      .collection("record")
                                      .doc(DateFormat('dd MMM yyy')
                                          .format(DateTime.now()))
                                      .update({
                                    'date': Timestamp.now(),
                                    'checkin': checkin,
                                    'checkout': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    'checkinlocation': location,
                                  });
                                } catch (e) {
                                  setState(() {
                                    checkin = DateFormat('hh:mm')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("karyawan")
                                      .doc(snap.docs[0].id)
                                      .collection("record")
                                      .doc(DateFormat('dd MMM yyy')
                                          .format(DateTime.now()))
                                      .set({
                                    'date': Timestamp.now(),
                                    'checkin': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    'checkout': "--/--",
                                    'checkoutlocation': location,
                                  });
                                }

                                key.currentState!.reset();
                              });
                            }
                          },
                        );
                      },
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 24),
                    child: Text(
                      'Kamu telah menyelesaikan hari ini!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ),
                    ),
                  ),
            location != " "
                ? Text(
                    "Location: " + location,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
