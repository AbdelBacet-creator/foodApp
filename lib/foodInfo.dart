import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodapp/cart.dart';
import 'dart:convert';

import 'package:foodapp/login.dart';

class FoodInfo extends StatefulWidget {
  final String? itemId;
  const FoodInfo(@required this.itemId);
  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  bool _isLiked = false;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    if (auth.currentUser != null) {
      setState(() {
        user = auth.currentUser;
      });
    }
  }

  Container MyParts(String, imageVal) {
    return Container(
        color: Color.fromARGB(225, 239, 238, 238),
        width: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: String,
          fit: BoxFit.contain,
          errorWidget: (context, url, error) => const Center(
              child: FittedBox(
            child: Text("Something went wrong!"),
          )),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ));
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

  Route _toCart() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ShoppingCartInside(),
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
        appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.black,
            toolbarHeight: 70,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(_toCart());
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                     size: 30,
                    color: Color.fromARGB(255, 232, 255, 59),
                  )),
            ]),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('food')
              .doc(widget.itemId)
              .snapshots(),
          builder: (context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap.hasError) {
              return Center(
                child: Text('Error!'),
              );
            } else {
              final data = snap.data;
              return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Container(
                                    height: 300,
                                    padding: const EdgeInsets.all(0),
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child: PageView.builder(
                                      itemCount: 1,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return MyParts(data['url'], "");
                                      },
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Text(
                                          data['title'],
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Color.fromARGB(
                                                  255, 48, 48, 48),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            data['price'].toString() + ' USD',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '~ ' +
                                                data['weight'].toString() +
                                                ' g',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  225, 239, 238, 238),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                          153, 255, 255, 255)
                                                      .withOpacity(0.3),
                                                  spreadRadius: 6,
                                                  blurRadius: 7,
                                                  offset: Offset(3,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 17.5,
                                              right: 17.5),
                                          child: Text(
                                            data['category'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 17.5, right: 17.5),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  height: 70,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['description'],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: true,
                                                  elevation: 5,
                                                  context: context,
                                                  builder: (context) {
                                                    if (user != null) {
                                                      return OrderPopUp(
                                                          user!.uid,
                                                          data['id'],
                                                          data['title'],
                                                          data['price'].toDouble(),
                                                          data['url']);
                                                    } else {
                                                      var snackBar = SnackBar(
                                                          action:
                                                              SnackBarAction(
                                                                  label:
                                                                      'Sign up',
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                            _toLogin());
                                                                  }),
                                                          content: Text(
                                                              'You need to sign up!'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      return SizedBox();
                                                    }
                                                  });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color.fromARGB(
                                                    255, 46, 46, 46),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              child: const Text(
                                                'Add To Cart',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ));
            }
          },
        )));
  }
}

class OrderPopUp extends StatefulWidget {
  final String uid;
  final String itemId;
  final String itemTitle;
  final double itemPrice;
  final String itemUrl;
  const OrderPopUp(
      @required this.uid,
      @required this.itemId,
      @required this.itemTitle,
      @required this.itemPrice,
      @required this.itemUrl);

  @override
  State<OrderPopUp> createState() => _OrderPopUpState();
}

class _OrderPopUpState extends State<OrderPopUp> {
  int quantity = 1;
  double totalPrice = 0;
  List<String> cartItems = [];
  bool isItemInCart = false;

  void initState() {
    // getCartItems();
    super.initState();
  }

  Future _isItemInCart() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('cart')
        .doc(widget.itemId)
        .get()
        .then((docSnapshot) => {
              setState(() {
                isItemInCart = docSnapshot.exists;
              })
            });
  }

  addToCart(int quantity, double totalPrice) async {
    await _isItemInCart().then((value) async {
      if (isItemInCart == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color.fromARGB(255, 41, 41, 41),
          content: Text(
            'Already in cart!',
            style: TextStyle(color: Colors.white),
          ),
        ));
        return null;
      } else {
        Object toAdd = {
          "id": widget.itemId,
          "title": widget.itemTitle,
          "unitPrice": widget.itemPrice,
          "url": widget.itemUrl,
          "totalPrice": totalPrice,
          "quantity": quantity
        };
        WriteBatch writeBatch = FirebaseFirestore.instance.batch();
        CollectionReference orderuser = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('cart');
        DocumentReference orderuser1 = orderuser.doc(widget.itemId);
        writeBatch.set(orderuser1, toAdd as Map<String, dynamic>);
        await writeBatch.commit().then(
            (value) => {
                  Navigator.pop(context),
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Color.fromARGB(255, 41, 41, 41),
                    content: Text(
                      'Added to cart!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                }, onError: (error) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color.fromARGB(255, 41, 41, 41),
            content: Text(
              error,
              style: const TextStyle(color: Colors.white),
            ),
          ));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = widget.itemPrice * quantity;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: MediaQuery.of(context).size.height / 3,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              'Quantity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuantityCounter((int value) {
                setState(() {
                  quantity = value;
                });
              }),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 85,
                  child: FittedBox(
                    child: Text(
                      totalPrice.toString() + ' usd',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => addToCart(quantity, totalPrice),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      primary: const Color.fromARGB(255, 46, 46, 46)),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Item will be added to shopping cart',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityCounter extends StatefulWidget {
  final Function(int) callback;
  const QuantityCounter(@required this.callback);

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  int quantity = 1;

  addOne() {
    if (quantity < 50) {
      setState(() {
        quantity++;
      });
      widget.callback(quantity);
    } else {
      return null;
    }
  }

  removeOne() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.callback(quantity);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 232, 255, 59)),
                onPressed: () => removeOne(),
                child: const Icon(
                  Icons.remove,
                  size: 18,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    width: 0.5, color: const Color.fromARGB(96, 0, 0, 0))),
            child: Center(
              child: FittedBox(
                child: Text(quantity.toString()),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // ignore: sized_box_for_whitespace
          Container(
              height: 30,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 232, 255, 59)),
                  onPressed: () => addOne(),
                  child: const Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.black,
                  ))),
        ],
      ),
    );
  }
}
