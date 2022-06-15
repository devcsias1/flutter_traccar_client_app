import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qmodi_tracking/constants.dart';
import 'package:qmodi_tracking/repository/location_repository.dart';

class LogScreen extends StatelessWidget{
final _locationRepository=Get.find<LocationRepository>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

appBar: AppBar(
  title:  const Text("Qmodi tracking Client",style: TextStyle(fontSize: 14,color: Colors.white,),
),
actions: [
 GestureDetector(
   onTap: (){
_locationRepository.clearLog();
   },
   child:const Center(child: Text("Clear",style: TextStyle(fontSize: 16,color: Colors.white,),))),
 SizedBox(width: 10,)
],

    ),
    body: Obx(
 
 () {
        return Container(
    
          width: Get.width,
          height: Get.height,
          child: ListView.separated(itemBuilder: ((context, index) => Text("${_locationRepository.allLog[index].time!.formatDate(pattern:"hh:mm a")} -  ${_locationRepository.allLog[index].info}",style:TextStyle(color:Colors.black,fontSize:15))), separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ), itemCount: _locationRepository.allLog.length),
    
    
        );
      }
    ),
    );
  }
}