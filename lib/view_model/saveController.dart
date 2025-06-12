import 'package:get/get.dart';

class saveController extends GetxController {

   RxSet<String> savedColleges = <String>{}.obs;

  void toggleSave(String collegeId) {
    if (savedColleges.contains(collegeId)) {
      savedColleges.remove(collegeId);
    } else {
      savedColleges.add(collegeId);
    }
  }

  bool isSaved(String collegeName) {
    return savedColleges.contains(collegeName);
  }

}
