import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/login.dart';
import 'prof widgets/profile_widget.dart';
import 'prof widgets/textfield_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late bool isLoggedIn;
  void initState() {
    auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const loginpage()));
      }
    });
    super.initState();
  }

  updateProfile(){
    
  }

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid.toString();
    String displayName = auth.currentUser!.displayName.toString();
    String profileUrl = auth.currentUser!.photoURL.toString();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
        toolbarHeight: 70,
      ),
      body: Center(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snap) {
              if (!snap.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 0, 0, 0))),
                );
              } else {
                if (snap.hasData) {
                  final data = snap.data;
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 40,),
                      ProfileWidget(
                        imagePath:
                            'https://cdn.pixabay.com/photo/2016/11/18/19/07/happy-1836445_960_720.jpg',
                        isEdit: true,
                        onClicked: () async {},
                      ),
                      const SizedBox(height: 24),
                      
                      TextFieldWidget(
                        label: 'Display Name',
                        text: data!['name'],
                        onChanged: (name) {},
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'Phone number',
                        text: data!['phonenumber'],
                        onChanged: (name) {},
                      ),
                      const SizedBox(height: 24),
                      TextFieldWidget(
                        label: 'Adress',
                        // text: data!['address'],
                        text: data!['address'],
                        maxLines: 5,
                        onChanged: (about) {},
                      ),
                    ],
                  );;
                } else if (snap.connectionState == ConnectionState.none) {
                  return Center(
                    child: Column(
                      children: [
                       const Text('Check your internet connection!'),
                        const SizedBox(
                          height: 5,
                        ),
                       const  Icon(
                          Icons.error,
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  );
                } else {
                  return const loginpage();
                }
              }
            }),
      ),
    );
  }
}
