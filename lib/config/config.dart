// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart';


import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase/firebase.dart';
// import 'package:firebase/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AutoParts {
  static const String appName = 'AutoParts';

   /*static Future init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String stringValue = preferences.getString('stringValue');
        return stringValue;
  }*/


  static FirebaseAuth ?auth;/*= FirebaseAuth.instance;*/
  static User? user;
  // static SharedPreferences preferences=SharedPreferences.getInstance() as SharedPreferences ;
   static SharedPreferences? preferences;

  static FirebaseFirestore ?firestore;/*=FirebaseFirestore.instance;*/

  static String collectionUser = "users";
  static String collectionOrders = "orders";
  static String userCartList = 'userCart';
  static String userWishList = 'userWishList';
  static String userServiceList = 'userService';
  static String subCollectionAddress = 'userAddress';

  static final String userName = 'name';

  static final String userEmail = 'email';
  static final String userPhone = 'phone';
  static final String userAddress = 'address';
  static final String userPhotoUrl = 'photoUrl';
  static final String userUID = 'uid';
  static final String userAvatarUrl = 'url';


  static final String addressID = 'addressID';
  static final String totalPrice = 'totalPrice';
  static final String productID = 'productIDs';
  static final String paymentDetails = 'paymentDetails';
  static final String orderTime = 'orderTime';
  static final String isSuccess = 'isSuccess';
}
