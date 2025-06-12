import 'package:my_campus_info/model/college.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  var allColleges = <College>[].obs;
  var filteredColleges = <String, List<College>>{}.obs;
  var selectedFilters = <String, String>{}.obs;

  void selectFilterForSection(String section, String stream) {
    selectedFilters[section] = stream;
    filteredColleges[section] =
        allColleges.where((college) {
          return college.stream == stream;
        }).toList();
  }

  bool isSelected(String section, String stream) =>
      selectedFilters[section] == stream;
}
