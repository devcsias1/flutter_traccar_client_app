import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qmodi_tracking/repository/auth_repository.dart';
import 'package:qmodi_tracking/repository/location_repository.dart';
import 'package:qmodi_tracking/sms_otp.dart';
import 'package:qmodi_tracking/update_profile.dart';

import 'dashboard.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // final AuthRepository ctrl = Get.find();
   final _authController=Get.find<AuthRepository>();
   final _locationController=Get.find<LocationRepository>();
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 10);
    return new Timer(duration, route);
  }

  route() async {
   LocationPermission permission = await Geolocator.checkPermission();
  
  if(permission==LocationPermission.denied || permission==LocationPermission.deniedForever || permission==LocationPermission.unableToDetermine){

await _locationController.showDeclaration();
print("permission is declined");
  }else{

print("permission is accepted");
  }

if(FirebaseAuth.instance.currentUser==null){
Get.off(SendOtp());
}else{
  if(_authController.MUser.value!=null){
Get.off(Dashboard());
  }else{

    Get.off(UpdateProfile());
  }

}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons.png',
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }
}
