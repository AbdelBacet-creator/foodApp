import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/cart.dart';
import 'package:foodapp/foodInfo.dart';
import 'package:foodapp/login.dart';
import 'package:foodapp/orderhistory.dart';
import 'package:foodapp/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    auth.authStateChanges().listen((event) {
      if (event != null) {
        setState(() {
          user = event;
        });
      } else {
        Navigator.push(context, _toLogin());
      }
    });
  }

  Route _toLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new loginpage(),
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

  Route _toCart() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ShoppingCartInside(),
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

  Route _toInsideItem(String param) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new FoodInfo(param),
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

  Route _toUSerInfo() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => new Profile(),
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

  Route _toOrderHistory() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          new orderhistory(),
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
    return Scaffold(
      backgroundColor: Color.fromARGB(227, 255, 255, 255),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          padding: EdgeInsets.only(top: 60, bottom: 30, left: 25, right: 25),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Food App',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.of(context).push(_toOrderHistory());
                    }),
                    child: Icon(
                      Icons.history,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.of(context).push(_toCart());
                    }),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: Color.fromARGB(255, 232, 255, 59),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.of(context).push(_toUSerInfo());
                    }),
                    child: Icon(
                      Icons.account_circle,
                      size: 30,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our newest dishes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('food').snapshots(),
                builder: (context, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    final data = snap.data.docs;
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(_toInsideItem(data[index]['id']));
                              },
                              child: Container(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    30,
                                height: 30,
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(77, 199, 202, 174)
                                          .withOpacity(0.5),
                                      spreadRadius: 6,
                                      blurRadius: 10,
                                      offset: Offset(
                                          3, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      padding: EdgeInsets.all(10),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        errorWidget: (context, url, error) =>
                                            Text("error"),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 100,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        imageUrl: data[index]['url'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          child: Image(
                                            image: imageProvider,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data[index]['title'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  data[index]['price']
                                                          .toString() +
                                                      ' usd',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.deepOrange,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color.fromARGB(160,
                                                              201, 199, 199)
                                                          .withOpacity(0.5),
                                                      spreadRadius: 3,
                                                      blurRadius: 5,
                                                      offset: Offset(2,
                                                          2), // changes position of shadow
                                                    ),
                                                  ]),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_right_rounded,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text('connecting to network...'),
                      ),
                    );
                  } else if (snap.hasError) {
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                }),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Explore our Food',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('food').snapshots(),
                builder: (ontext, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    final data = snap.data.docs;
                    return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 180,
                                childAspectRatio: 6 / 8,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(_toInsideItem(data[index]['id']));
                            },
                            child: Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(77, 199, 202, 174)
                                        .withOpacity(0.5),
                                    spreadRadius: 6,
                                    blurRadius: 10,
                                    offset: Offset(
                                        3, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 140,
                                    padding: EdgeInsets.all(5),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      errorWidget: (context, url, error) =>
                                          Text("error"),
                                      placeholder: (context, url) => Container(
                                        height: 140,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      imageUrl: data[index]['url'],
                                      imageBuilder: (context, imageProvider) =>
                                          ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                        child: Image(
                                          image: imageProvider,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              data[index]['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                data[index]['price']
                                                        .toString() +
                                                    ' usd',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.deepOrange,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                            160, 201, 199, 199)
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 5,
                                                    offset: Offset(2,
                                                        2), // changes position of shadow
                                                  ),
                                                ]),
                                            child: Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (snap.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: const Center(
                        child: Text('connecting to network...'),
                      ),
                    );
                  } else if (snap.hasError) {
                    return const Center(
                      child: Text('Something went wrong!'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
