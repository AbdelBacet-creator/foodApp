import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodapp/login.dart';

class orderhistory extends StatefulWidget {
  const orderhistory({Key? key}) : super(key: key);

  @override
  _orderhistoryState createState() => _orderhistoryState();
}

class _orderhistoryState extends State<orderhistory> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    if (auth.currentUser != null) {
      user = auth.currentUser;
    } else {
      Navigator.of(context).push(_toLogin());
    }
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

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 214, 214, 214),
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.black,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Text('Order history',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        ),
        body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('orders').orderBy('timestamp',descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    final data = snap.data.docs;
                    return data.length>0 ? AnimationLimiter(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 575),
                                child: FlipAnimation(
                                  child: FadeInAnimation(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 7.5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                60, 103, 103, 103),
                                            offset: Offset(1, 1),
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                          )
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index]['orderid'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    data[index]['totlaprice'].toString()+' usd',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                data[index]['phonenumber'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                data[index]['adress'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(
                                                'at ' +
                                                   DateTime.fromMillisecondsSinceEpoch( data[index]['timestamp'])
                                                        .toString(),
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                         Text(data[index]['orderstatus'],style: TextStyle(color:
                                         data[index]['orderstatus'] == 'pending' ?  Colors.orange:
                                         data[index]['orderstatus'] == 'canceled' ?  Colors.red:
                                         data[index]['orderstatus'] == 'started' ?  Colors.green:
                                         Colors.grey)),
                                         
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })):Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text('You have made no orders yet!',style: TextStyle(fontSize: 20),),
                              SizedBox(
                                height: 15,
                              ),
                              Icon(Icons.error,color: Colors.green,)
                            ],
                              ),
                            );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('Connecting to internet..')
                        ],
                      ),
                    );
                  } else if (snap.hasError) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Something went wrong!')],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    );
                  }
                })));
  }}