import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart'as http;
import 'package:qmodi_tracking/applink.dart';
import 'package:qmodi_tracking/model/user.dart';

import '../dashboard.dart';
import '../update_profile.dart';
enum Status {
  IsFirstTime,
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  invalid_email,
  wrong_password,
  user_not_found,
  too_many_requests,
  operation_not_allowed,
  user_disabled,
  unknown,
  isLoading,
  Success,
  Error,
  Phone_Number_Existed,
  GoogleSigninLoading
}
class AuthRepository extends GetxController{
FirebaseAuth firebaseAuth=FirebaseAuth.instance;
String? userId;

  TextEditingController phoneNumberController=TextEditingController();

  String countryText="234";
    final status = Status.Uninitialized.obs;

  Rx<UserModel?> MUser=Rx(null);
  UserModel? get user=>MUser.value;
  String countryCode="1";
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
@override
  void onInit()async{
    // TODO: implement onInit
    super.onInit();
  
  if(firebaseAuth.currentUser!=null){
    // firebaseAuth.signOut();
    print("user id is ${firebaseAuth.currentUser!.uid}");
      updateUserToken();
  final user= await getUser(firebaseAuth.currentUser!.uid);
  if(user==null)
  return;
// print("getting user detail is ${user!.toFJson()}");
   MUser(user);
   
 
//    if(user.tracar_id==null){
//      print("user id from auth is ${firebaseAuth.currentUser!.uid}");
//     //  user.email="Olu12467@gmail.com";
//     //  user.name="Olu Tope";

//     createProfile(user);
//     // updateToken(user);
    
   
//    }
//  if(user.deviceId==null){

//    registerDevice(user);
//  }

  if(user.token==null){
 updateToken(user);
  }
  }
  


  }

  void signinWithPhoneNumber(UserCredential Muser) async{


   Get.off(Dashboard());


  }
  // }
  //   Future<UserModel?> getUser(String id) async {
  //   print("user from get user is $id");
  //   final value = await AuthService().getUser(id);
  //   if (value != null) print("getting user ${value.toJson()}");

  //   return value;
  // }

  CollectionReference userRef()=> FirebaseFirestore.instance.collection("users");
UserModel? _currentUser;
  Future<UserModel?> getUser(String id)async{
UserModel? user;
   final userData= await userRef().doc(id).get();
   if(userData.data()!=null){
   user=UserModel.fromFJson(userData.data()!);
   _currentUser=user;
   }else{
     user=null;
   }

   return user;

  }

  void createProfile(UserModel user) {


   

user.id=userId;
user.phone=countryCode+phoneNumberController.text;
userRef().doc(userId).set(user.toFJson());
// createTracarUser(user);
updateToken(user);
// registerDevice(user);
MUser(user);
   Get.off(Dashboard());

  }

//   Future createTracarUser(UserModel user)async{

// try{

// final response= await http.post(Uri.parse(AppLink.userUrl),body: jsonEncode(user.toJson()),headers: {

//   "Authorization":"Basic dGhlZGV2QWNjZXNzLjEyQGdtYWlsLmNvbTp0aGVkZXZBY2Nlc3M=",
//   "Content-Type":"application/json"
// }

// );
// if(kDebugMode) {
//   print("creating user traccar ${response.body}");
// }

// if (response.statusCode==200){
// final json=jsonDecode(response.body);
// int id=json['id'];
// user.tracar_id=id;
// userRef().doc(firebaseAuth.currentUser!.uid).update(user.toFJson());
// MUser(user);
// }
// }catch(ex){
// if(kDebugMode) {
//   print("an error ocuccreed ${ex.toString()}");
// }

// }



//   }
// Future updateTracarUser(UserModel user)async{

// try{
// print("update profile json ${user.toJson()}");
// final response= await http.put(Uri.parse("${AppLink.userUrl}${user.tracar_id}"),body: jsonEncode(user.toJson()),headers: {

//   "Authorization":"Basic dGhlZGV2QWNjZXNzLjEyQGdtYWlsLmNvbTp0aGVkZXZBY2Nlc3M=",
//   "Content-Type":"application/json"
// }

// );
//  if(kDebugMode) {
//    print("response for update location ${response.body}");
//  }
// if (response.statusCode==200){

// final json=jsonDecode(response.body);
// int id=json['id'];
// user.tracar_id=id;
// userRef().doc(firebaseAuth.currentUser!.uid).update(user.toFJson());
// MUser(user);

// }

// }catch(ex){


// }



// }

Future updateToken(UserModel user)async{

try{

final fcmToken = await FirebaseMessaging.instance.getToken();
user.token=fcmToken;
print("fcmToken is $fcmToken");
print("result of phone number is ${user.phone}");
final response= await http.get(Uri.parse("${AppLink.updateTokenUrl}?id=${user.phone}&DeviceToken=$fcmToken")

);
 if(kDebugMode)
 print("response for update token ${response.body}");
if (response.statusCode==200){

// final json=jsonDecode(response.body);
// int id=json['id'];
// user.tracar_id=id;
// userRef().doc(userId).update(user.toFJson());
// MUser(user);

}

}catch(ex){




}

}

// Future registerDevices(UserModel user)async{
//    var deviceData = <String, dynamic>{};
//    String? model="";
// if(Platform.isAndroid){
// model=(await deviceInfoPlugin.androidInfo).model;


// }else if(Platform.isIOS){

//   model=(await deviceInfoPlugin.iosInfo).model;
// }
// try{

// final response= await http.post(Uri.parse(AppLink.deviceUrl),body: jsonEncode({
// "name": user.name!+" Phone",
// "uniqueId":user.phone,



// "phone": user.phone,
// "model":model
// }),headers: {

//  "Authorization":"Basic dGhlZGV2QWNjZXNzLjEyQGdtYWlsLmNvbTp0aGVkZXZBY2Nlc3M=",
//   "Content-Type":"application/json"
// });

// if(kDebugMode) {
//   print("register device ${response.body}");
// }
// if(response.statusCode==200){

// user.deviceId=firebaseAuth.currentUser!.uid;

// userRef().doc(firebaseAuth.currentUser!.uid).update(user.toFJson());
// MUser(user);
// }
// }catch(ex){

// if(kDebugMode) {
//   print("register device error ${ex.toString( )}");
// }

// }

// }
Future updateUserToken()async{

final fcmToken = await FirebaseMessaging.instance.getToken();
FirebaseFirestore.instance.collection("userToken").doc(FirebaseAuth.instance.currentUser!.uid).set({

  "token":fcmToken,
  "phoneNumber":FirebaseAuth.instance.currentUser!.phoneNumber
});



}
}
