import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/Loading.dart';
import 'package:pms/Services/Authentication.dart';
import 'package:pms/Services/FirebaseOperations.dart';
import 'package:pms/Staff/StaffHomePage.dart';
import 'package:pms/Student/StudentHomePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  ConstantColors constantColors = ConstantColors();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String userEmail;

  String get getUserEmail => userEmail;
  String profession;

  String get getProfession => profession;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Lottie.asset('assets/animation/login.json'),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 40, bottom: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Material(
                                    elevation: 10,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(0.0),
                                            topRight: Radius.circular(30.0))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 40,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: TextFormField(
                                        cursorColor: constantColors.amber,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person_rounded,
                                            color: Colors.grey,
                                            size: 20.0,
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Username',
                                          hintStyle: TextStyle(
                                            color: Color(0xFFE1E1E1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 40, bottom: 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Material(
                                    elevation: 10,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(0.0),
                                            topRight: Radius.circular(30.0))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 40,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: TextFormField(
                                        obscureText: _obscureText,
                                        cursorColor: constantColors.amber,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                            size: 20.0,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                          border: InputBorder.none,
                                          hintText: 'Password',
                                          hintStyle: TextStyle(
                                            color: Color(0xFFE1E1E1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (usernameController.text.trim() != '' &&
                                  passwordController.text.trim() != '') {
                                try {
                                  setState(() {
                                    _loading = true;
                                  });
                                  final snapshots = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(usernameController.text
                                          .trim()
                                          .toLowerCase())
                                      .get();
                                  if (snapshots == null || !snapshots.exists) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    showToast('Enter Correct Username');
                                  } else {
                                    // setState(() {
                                    //   _loading=true;
                                    // });
                                    await Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .initUserData(context, snapshots.id);
                                    SharedPreferences shared =
                                        await SharedPreferences.getInstance();
                                    userEmail = snapshots.data()['useremail'];
                                    profession = snapshots.data()['profession'];

                                    // print(profession);
                                    // print('Logging In');
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .logIntoAccount(
                                            snapshots.data()['useremail'],
                                            passwordController.text.trim(),
                                            context)
                                        .whenComplete(() {
                                      // print('loggedIn');

                                      if (Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getErrorMessage !=
                                          '') {
                                        setState(() {
                                          _loading = false;
                                          shared.clear();
                                        });

                                        usernameController.clear();
                                        passwordController.clear();
                                        showToast(
                                            '${Provider.of<Authentication>(context, listen: false).getErrorMessage}');
                                      } else {
                                        if (Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getInitUserProfession ==
                                            'student') {
                                          // setState(() {
                                          //   _loading = false;
                                          // });
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: StudentHomePage(
                                                      // userUid: aUserUid,
                                                      ),
                                                  type: PageTransitionType
                                                      .bottomToTop));
                                          // print('Student logged in');
                                        } else if (Provider.of<
                                                        FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getInitUserProfession ==
                                            'staff') {
                                          // setState(() {
                                          //   _loading = false;
                                          // });
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  child: StaffHomePage(),
                                                  type: PageTransitionType
                                                      .rightToLeft));
                                          // print('Staff logged in');
                                        } else {
                                          setState(() {
                                            _loading = false;
                                            shared.clear();
                                          });
                                          showToast('Some Error Occurred!!!');
                                        }
                                      }
                                    });
                                  }
                                  // print(getUserEmail);
                                } catch (e) {
                                  // print(e.toString());
                                }

                                // print(usernameController.text.trim().toLowerCase());
                                // print(passwordController.text.trim());
                              } else {
                                showToast('Enter Valid Credentials');
                                usernameController.clear();
                                passwordController.clear();
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: <Color>[
                                  Color(0xFF0EDED2),
                                  Color(0xFF03A0FE),
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Container(
                                height: 50.0,
                                width: 220.0,
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        textColor: Colors.yellow);
  }
}
