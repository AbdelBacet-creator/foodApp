import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'login.dart';
import 'prof widgets/textfield_widget.dart';

class ShoppingCartInside extends StatefulWidget {
  const ShoppingCartInside();

  @override
  State<ShoppingCartInside> createState() => _ShoppingCartInsideState();
}

class _ShoppingCartInsideState extends State<ShoppingCartInside> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  List items = [];
  double totalprice = 0.0;
  void initState() {
    authChanged();
    super.initState();
  }

  authChanged() {
    if (auth.currentUser != null) {
      setState(() {
        user = auth.currentUser;
      });
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
    final WIDTH = MediaQuery.of(context).size.width;
    String uid = auth.currentUser!.uid;
    String username = auth.currentUser!.displayName.toString();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
      body: RefreshIndicator(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                shadowColor: Colors.transparent,
                pinned: true,
                toolbarHeight: 70,
                floating: true,
                forceElevated: true,
                titleSpacing: 0,
                title: Container(
                  height: 50,
                  width: WIDTH,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shopping Cart ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('cart')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData) {
                      final data = snap.data.docs;
                      Object obj;
                      totalprice = 0.0;
                      data.forEach((doc) {
                        obj = {
                          "id": doc['id'],
                          "quantity": doc['quantity'],
                          "title": doc['title'],
                          "totalPrice": doc['totalPrice'],
                          "unitPrice": doc['unitPrice'],
                          "url": doc['url'],
                        };
                        //this is where total price is calcuated
                        totalprice = totalprice + doc['totalPrice'];
                        items.add(obj);
                      });
                      return data.length > 0
                          ? AnimationLimiter(
                              child: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 575),
                                  child: FlipAnimation(
                                    child: FadeInAnimation(
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        width: WIDTH,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        alignment: Alignment.bottomCenter,
                                        child: ListTile(
                                          leading: CachedNetworkImage(
                                              // imageUrl:
                                              //     items[index]['url'],
                                              imageUrl: data[index]['url'],
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Text("error"),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image: imageProvider,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                          // title: Text(items[index]['id'],style: TextStyle(color: Theme.of(context).colorScheme.primary,),),
                                          // subtitle: Text(items[index]['id'],style: TextStyle(color: Theme.of(context).colorScheme.primary,)),
                                          title: Text(
                                            data[index]['title'].length > 14
                                                ? data[index]['title']
                                                    .substring(0, 14)
                                                : data[index]['title'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(
                                              data[index]['unitPrice']
                                                      .toString() +
                                                  ' usd x ' +
                                                  data[index]['quantity']
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          trailing: Text(
                                            data[index]['totalPrice']
                                                    .toString() +
                                                ' usd',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }, childCount: data.length)),
                            )
                          : SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Nothing in cart yet!',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Icon(
                                    Icons.error,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            );
                    } else if (snap.connectionState ==
                        ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Connecting to internet !',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(Icons.error)
                        ],
                      ));
                    } else if (snap.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Something went wrong!'),
                        ),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }
                  }),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.all(10),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Text(
              //           'Total : ' + totalprice.toString() + ' usd',
              //           style: Theme.of(context).textTheme.titleMedium,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          primary: Colors.black),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => BottomSheetOrder(
                                uid, username, totalprice, items));
                      },
                      child: Text('Checkout')),
                ),
              )
            ],
          ),
          color: Colors.green,
          onRefresh: () async {}),
    );
  }
}

class BottomSheetOrder extends StatefulWidget {
  final String userid;
  final String username;
  final double totlaprice;
  final List Items;

  const BottomSheetOrder(@required this.userid, @required this.username,
      @required this.totlaprice, @required this.Items);

  @override
  _BottomSheetOrderState createState() => _BottomSheetOrderState();
}

class _BottomSheetOrderState extends State<BottomSheetOrder> {
  submitOrder(String adress, String phonenumber) async {
    var timestamp =
        DateTime.now().add(Duration(hours: 10)).millisecondsSinceEpoch;
    var id = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userid)
        .collection('orders')
        .doc()
        .id;
    // orderstatus
    var data = {
      "orderid": id,
      "orderstatus": "pending",
      "userid": widget.userid,
      "username": widget.username,
      "totlaprice": widget.totlaprice,
      "adress": adress,
      "items": widget.Items.toList(),
      "timestamp": timestamp,
      "phonenumber": phonenumber
    };
    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    CollectionReference orderuser = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userid)
        .collection('orders');
    DocumentReference orderuser1 = orderuser.doc(id);
    writeBatch.set(orderuser1, data);
    CollectionReference order = FirebaseFirestore.instance.collection('orders');
    DocumentReference order1 = order.doc(id);
    writeBatch.set(order1, data);
    await writeBatch.commit().then((value) async {
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userid)
          .collection('cart');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text(
          'Order confirmed! ',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }, onError: (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 41, 41, 41),
        content: Text(
          'Unable to confirm order!',
          style: TextStyle(color: Colors.white),
        ),
      ));
      print(error);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userid)
            .snapshots(),
        builder: (context, AsyncSnapshot snap) {
          if (snap.hasData) {
            final data = snap.data;
            return data['address'] != ''
                ? Container(
                    height: MediaQuery.of(context).size.height / 4,
                    padding: const EdgeInsets.only(
                        top: 30, left: 15, right: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.totlaprice.toString()+ ' USD in total',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Sure you wanna confirm order?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        Color.fromARGB(255, 199, 188, 188)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                )),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                onPressed: () {
                                  submitOrder(
                                      data['address'], data['phonenumber']);
                                },
                                child: Text('Confirm',
                                    style: TextStyle(color: Colors.white)))
                          ],
                        )
                      ],
                    ))
                : Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 20),
                    height: MediaQuery.of(context).size.height / 6,
                    child: Column(
                      children: [
                        Text('You need to specify your adress!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15)),
                              // onPressed: () {
                              //   Navigator.of(context).push(_toProfile());
                              // },
                              onPressed: () {},
                              child: Text('Go to profile')),
                        )
                      ],
                    ),
                  );
          } else if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('connecting to network...'),
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
        });
  }
}
