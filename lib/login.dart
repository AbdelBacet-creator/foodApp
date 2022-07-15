import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/account.dart';
import 'package:foodapp/homepage.dart';
import 'package:foodapp/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../config/config.dart';
import 'common/theme_helper.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final password = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Future<FirebaseApp> _future = Firebase.initializeApp();
    double _headerHeight = 250;
    final _formKey = GlobalKey<FormState>();

    Future readEmailSignInUserData(User fUser) async {
      FirebaseFirestore.instance
          .collection("users")
          .doc(fUser.uid)
          .get()
          .then((dataSnapshot) async {
        await AutoParts.preferences!
            .setString("uid", dataSnapshot.data()![AutoParts.userUID]);
        await AutoParts.preferences!.setString(
            AutoParts.userEmail, dataSnapshot.data()![AutoParts.userEmail]);
        await AutoParts.preferences!.setString(
            AutoParts.userName, dataSnapshot.data()![AutoParts.userName]);
      });
    }

    Future saveUserGoogleSignInInfoToFirebase(User currentUser) async {
      FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
        "uid": currentUser.uid,
        "Firstname": currentUser.displayName,
        "email": currentUser.email,
        "mobile": currentUser.phoneNumber
      });
      await AutoParts.preferences!.setString("uid", currentUser.uid);
      await AutoParts.preferences!
          .setString(AutoParts.userEmail, currentUser.email.toString());
      await AutoParts.preferences!
          .setString(AutoParts.userName, currentUser.displayName.toString());
      await AutoParts.preferences!.setString(AutoParts.userPhone, '');
      await AutoParts.preferences!.setString(AutoParts.userAddress, '');
    }
    Route _toHomePage() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
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

    Future<void> login(String data, String data2) async {
      User fUser;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: data,
        password: data2,
      )
          .then((value) {
        Navigator.of(context).push(_toHomePage());
        return value.credential as UserCredential;
      });
      fUser = userCredential.user as User;
      readEmailSignInUserData(fUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text(
          'login successfuly!!!',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }

    Future init() async {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
    }

    Route _toSignUp() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const signuppage(),
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
                        const SizedBox(
                          height: 70,
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 7.5),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  // margin: EdgeInsets.fromLTRB(
                                  //     20, 10, 20, 10),
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Email', 'Enter your Email '),
                                    controller: name,
                                    validator: (val) {
                                      if ((val!.isEmpty) |
                                          !RegExp(r"^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)$")
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
                                        return "Please enter your password";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(100, 0, 100, 0),
                                      child: Text(
                                        'Login'.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final user =
                                            login(name.text, password.text)
                                                .catchError((onError) => {
                                                      if (onError)
                                                        {
                                                          print("8alatttttt" +
                                                              onError),
                                                        }
                                                    })
                                                .then(
                                                  (value) =>
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              _toHomePage(),
                                                              (_) => false),
                                                );
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .push(_toSignUp());
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).accentColor),
                                    ),
                                  ])),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
