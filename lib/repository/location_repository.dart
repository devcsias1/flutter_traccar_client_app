import 'dart:async';
import 'dart:io';

import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qmodi_tracking/applink.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/log.dart';
import '../model/user.dart';
import 'auth_repository.dart';


class LocationRepository extends GetxController{

final _authController =Get.find<AuthRepository>();
Rx<List<Log>> _allLog=Rx([]);
List<Log> get allLog=>_allLog.value;
StreamSubscription<Position>? locationStream;
@override
  void onInit()async {
    // TODO: implement onInit
    super.onInit();
if (kDebugMode) {
  print("oninit for location repo");
}
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.always || permission==LocationPermission.whileInUse){


 if(Platform.isAndroid){


  BackgroundLocation.setAndroidNotification(
	title: "Qmodi Tracking",
        message: "Qmodi Tracking",
        icon: "@mipmap/ic_launcher",
);
BackgroundLocation.setAndroidConfiguration(1000);
}
 BackgroundLocation.startLocationService();

    }




readLocation();

 setupInteractedMessage();

  }

    Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
 void _handleMessage(RemoteMessage message) {
  
 String? url= message.data['url'];
launchUrl(
      Uri(scheme: 'https', host: url,),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    );
  }
Future readLocation()async{
  print("reading location");
locationStream= Geolocator.getPositionStream().listen((event) {
  print("new position detected ${event.latitude} ${event.longitude}");

  
  if(FirebaseAuth.instance.currentUser!=null){

updatePosition(event);
print("getting new position is ${event.latitude} ${event.longitude}");
  }

});

BackgroundLocation.getLocationUpdates((location) {
  print(location);
final user=_authController.user;  
updateBackgroundPosition(location, user!);
});


}

Future updatePosition(Position position)async{

if (kDebugMode) {
  // print("trying to update position ${user.phone}");
}
Log item=Log(time:DateTime.now(),info: "Service Started");
final allList=allLog;
allList.add(item);
try{

final result=await http.post(Uri.parse("${AppLink.baseUrl}/?id=${FirebaseAuth.instance.currentUser!.phoneNumber}&lat=${position.latitude}&lon=${position.longitude}&time=${DateTime.now().toIso8601String()}&accuracy=${position.accuracy}&speed=${position.speed}&course=${position.heading}&altitude=${position.altitude}"));

if (kDebugMode) {
  print("response is ${result.body} ${result.statusCode}");
}

if(result.statusCode==200){

  if (kDebugMode) {
    print("status is changed successfully");
  }
Log item=Log(time:DateTime.now(),info: "Location Update ");
final allList=allLog;
allList.add(item);
}else{
  Log item=Log(time:DateTime.now(),info: "Location Update Failed");
final allList=allLog;
allList.add(item);

  if (kDebugMode) {
    print("status failed to cahnged");
  }
}

}catch(ex){

  Log item=Log(time:DateTime.now(),info: "Service Stopped");
final allList=allLog;
allList.add(item);


}



}

Future updateBackgroundPosition(Location position,UserModel user)async{

if (kDebugMode) {
  print("trying to update position ${user.deviceId}");
}
try{
final result=await http.post(Uri.parse("${AppLink.baseUrl}?id=${user.deviceId}&lat=${position.latitude}&lon=${position.longitude}&time=${DateTime.now().toIso8601String()}&accuracy=${position.accuracy}&speed=${position.speed}&course=${position.bearing}&altitude=${position.altitude}"));

if (kDebugMode) {
  print("response is ${result.body} ${result.statusCode}");
}

if(result.statusCode==200){

  if (kDebugMode) {
    print("status  background is changed successfully");
  }
}else{
  if (kDebugMode) {
    print("status background failed to cahnged");
  }
}

}catch(ex){




}



}
Future showDeclaration()async{

await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title:  const Text("Location Permission Needed"),
          content:const  Text("Qmodi Tracking Android App collects\n" +
                            "location data to enable tracking yours\n" +
                            "several loads and calculate distance\n" +
                            "travelled when app is working or even when\n" +
                            "the app is closed or not in use.\n" +
                            "\n" +
                            "This data will be uploaded to qmodi.com\n" +
                            "where you can view and/or delete your\n" +
                            "location(Loads) tavelled history.\n" +
                            "\n" +
                            "Qmodi Tracking Android App collects location data to enable\n" +
                            "1. Estimate/Actual Time Needed for each load trips\n" +
                            "2. Distance traveled (Actual vs as on load map) estimate vs actual\n" +
                            "3. Marking and Notifying on entry and exit of each Geo fence (Stops) in the load trips\n" +
                            "even when the app is closed or not in use.\n" +
                            "\n" +
                            "Qmodi Tracking Android App collects location data to enable\n" +
                            "1. Estimate/Actual Time Needed for each load trips\n" +
                            "2. Distance traveled (Actual vs as on load map) estimate vs actual\n" +
                            "3. Marking and Notifying on entry and exit of each Geo fence (Stops) in the load trips\n" +
                            "even when the app is closed or not in use and it is also used to support advertising."),
          actions: <Widget>[
            TextButton(
              onPressed: ()async{
LocationPermission permission = await Geolocator.requestPermission();
if(Platform.isAndroid){


  BackgroundLocation.setAndroidNotification(
	title: "Qmodi Tracking",
        message: "Qmodi Tracking",
        icon: "@mipmap/ic_launcher",
);
BackgroundLocation.setAndroidConfiguration(1000);
}
 BackgroundLocation.startLocationService();
 Get.back();
              },
              child: const Text('Procedd'),
            ),
           
          ],
        );
      },
    );
}
Future clearLog()async{
  _allLog([]);
}
Future stopReading()async{
locationStream!.cancel();
_allLog([]);
}
}