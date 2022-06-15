import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qmodi_tracking/repository/auth_repository.dart';

import 'custom_textfield.dart';
import 'model/user.dart';

class UpdateProfile extends StatelessWidget {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final _authController = Get.find<AuthRepository>();
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Profile"),
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                ),
                child: Text(
                  "Full Name",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  keyType: TextInputType.name,
                  hint: "Doe Joe",
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "Full name is required";
                    }
                  },
                  textEditingController: _fullnameController,
                
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text("Email",
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  keyType: TextInputType.emailAddress,
                  hint: "email",
                  validate: (val) {
                    if (val!.isEmpty) {
                      return "email is required";
                    }
                  },
                  textEditingController: _emailController,
                 
                ),
              ),
             
              const SizedBox(
                height: 40,
              ),
              Obx(() {
                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () {
                      print("update pressed");

                      UserModel? user = UserModel();
                      user.name = _fullnameController.text;
                      user.email = _emailController.text;
                      user.phone=_authController.countryCode+_authController.phoneNumberController.text;

                      if (_authController.status.value != Status.isLoading) {
                        // if (_formKey.currentState!.validate()) {
                        if ( _authController.user==null || _authController.user!.id == null ||
                            _authController.user!.id!.isEmpty) {
                          print("trying to create profile");

                          _authController.createProfile(user);
                        } else {
                      
                        }
                        
                      }
              
                    },
                    child: (_authController.status.value == Status.isLoading)
                        ? Center(
                            child: Container(
                                width: 30,
                                height: 30,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )),
                          )
                        : Text(
                           _authController.user==null|| _authController.user!.id == null
                                ? 'Create Profile'
                                : 'Update Profile',
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
