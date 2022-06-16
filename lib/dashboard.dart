import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qmodi_tracking/Log_screen.dart';
import 'package:qmodi_tracking/repository/auth_repository.dart';
import 'package:qmodi_tracking/repository/location_repository.dart';

class Dashboard extends StatefulWidget {
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool value = true;

  final _authController = Get.find<AuthRepository>();
  final _locationController = Get.find<LocationRepository>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Qmodi Tracking App Dashboard"), actions: [
        GestureDetector(
            onTap: () {
              Get.to(LogScreen());
            },
            child: Center(
                child: Text("Log",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    )))),
        const SizedBox(
          width: 10,
        )
      ]),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Service is Running",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Switch(
                      value: value,
                      onChanged: (bool value) {
                        setState(() {
                          this.value = value;
                        });
                        if (value) {
                          _locationController.readLocation();
                        } else {
                          _locationController.stopReading();
                        }
                      },
                    )
                  ],
                ),
              ),
            
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Phone",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "${FirebaseAuth.instance.currentUser!.phoneNumber ?? ""}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              
            ]),
      ),
    );
  }
}
