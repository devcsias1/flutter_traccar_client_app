import 'package:get/get.dart';
import 'package:qmodi_tracking/repository/auth_repository.dart';
import 'package:qmodi_tracking/repository/location_repository.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
  Get.put(AuthRepository(),permanent: true);
  Get.put(LocationRepository(),permanent: true);
  }
}