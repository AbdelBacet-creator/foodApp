import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/homepage.dart';
import 'package:foodapp/login.dart';

import '../config/config.dart';
import 'common/theme_helper.dart';

class signuppage extends StatefulWidget {
  const signuppage({Key? key}) : super(key: key);

  @override
  _signuppageState createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  double _headerHeight = 250;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  // final databaseRef = FirebaseDatabase.instance.reference();
  final email = TextEditingController();
  final phonenumber = TextEditingController();
  final displayname = TextEditingController();
  final adress = TextEditingController();
  final password = TextEditingController(); //database reference object
  final confirmpassword = TextEditingController(); //database reference object

  Route _toHomePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _toLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const loginpage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future createUser() async {
    User firebaseUser;

    await auth
        .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        )
        .whenComplete(() => {Navigator.of(context).push(_toHomePage())})
        .then((auth1) => {
              firebaseUser = auth1.user!,
              auth.currentUser!
                  .updateProfile(displayName: displayname.text.trim())
            })
        .catchError((error) {
      print(error);
    });
    saveUserInfoToFireStore(auth.currentUser!);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      content: Text(
        'Sign up successfuly!',
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": displayname.text,
      "phonenumber": phonenumber.text,
      "address": adress.text,
    });
    await AutoParts.preferences!.setString("uid", fUser.uid);
    await AutoParts.preferences!.setString(AutoParts.userEmail, fUser.email!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white, shadowColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 7.5),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Email', 'Enter your Email '),
                                    controller: email,
                                    validator: (val) {
                                      if ((val!.isEmpty) |
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                              .hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Display name', 'Enter your name'),
                                    controller: displayname,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Required enter your name";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Adress', 'Enter your adress'),
                                    controller: adress,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Required enter your adress";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     10, 10, 10, 10),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration('Phone number',
                                            'Enter your number'),
                                    controller: phonenumber,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Required enter your number";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                    controller: password,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Required enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 30.0),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: TextFormField(
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            ' Confirm your Password',
                                            'Confirm your password'),
                                    controller: confirmpassword,
                                    validator: (val) {
                                      if (val!.isEmpty)
                                        return 'Required confirm your password ';
                                      if (val != password.text)
                                        return 'Not Match';
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(_toLogin());
                                    },
                                    child: Text(
                                      'Or login',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          100, 0, 100, 0),
                                      child: Text(
                                        'Sign up'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        createUser()
                                            .catchError((onError) => {
                                                  if (onError)
                                                    {
                                                      print("8alatttttt" +
                                                          onError),
                                                    }
                                                })
                                            .then((value) =>
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        _toHomePage(),
                                                        (_) => false));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
