import 'package:get/get.dart';

class SelectionController extends GetxController {
  var selectedStates = <String>{}.obs;
  var selectedCities = <String>{}.obs;
  var selectedStreams = <String>{}.obs;

  void toggleStates(String item) {
    selectedStates.contains(item)
        ? selectedStates.remove(item)
        : selectedStates.add(item);
  }

  void toggleStream(String item) {
    selectedStreams.contains(item)
        ? selectedStreams.remove(item)
        : selectedStreams.add(item);
  }

  void toggleCities(String item) {
    selectedCities.contains(item)
        ? selectedCities.remove(item)
        : selectedCities.add(item);
  }
}
