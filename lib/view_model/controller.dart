import 'package:my_campus_info/model/college.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Controller extends GetxController{

  Rx<bool> isLoading = false.obs;
  Rx<bool> isLoggedIn = false.obs;
  Rx<bool> isGuestIn = false.obs;
  Rx<int> navSelectedIndex = 0.obs;
  RxList<College> predictedClg = <College>[].obs;

}