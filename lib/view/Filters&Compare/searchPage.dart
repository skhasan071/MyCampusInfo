import 'package:my_campus_info/services/college_services.dart';
import 'package:my_campus_info/view/Filters&Compare/search_res.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_campus_info/view_model/searchController.dart';
import '../../model/college.dart';

class SelectionPage extends StatefulWidget {

  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();

}

class _SelectionPageState extends State<SelectionPage> {

  final controller = Get.put(SelectionController());

  var searchCtrl = TextEditingController();

  // Countries
  final List<String> states = [
    'Maharashtra',
    'Karnataka',
    'Delhi',
    'Kerala',
    'Gujarat',
    'Tamil Nadu'
  ];

  final List<String> streams = [
    'Engineering',
    'Management',
    'Arts',
    'Science',
    'Law',
    'Medical',
    'Design',
    'Humanities',
  ];

  // Mapping of countries to their states
  final Map<String, List<String>> stateCities = {
    'Maharashtra' : ['Mumbai', 'Pune', 'Navi Mumbai', "Nagpur",],
    'Karnataka': ['Mangaluru', "Kalaburagi", 'Bangalore', 'Udupi'],
    'Delhi': ['Jamia Nagar', 'Dwarka', 'Rohini', 'New Delhi'],
    'Kerala' : ['Thiruvananthapuram', 'Kochi', 'Kottayam', 'Palakkad'],
    'Gujarat' : ['Surat', 'Ahmedabad', 'Gandhinagar', 'Anand'],
    'Tamil Nadu' : ['Chennai', 'Vellore', 'Tiruchirappalli', 'Krishnankoil']
  };

  // Initially display all states (this will update based on selected country)
  RxList<String> displayedCities = RxList<String>([]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(

        backgroundColor: Colors.white,

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  controller: searchCtrl,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    hintText: "Search here...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ), // removes ripple highlight on press
                            elevation: MaterialStateProperty.all(0),
                            shadowColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                          ),

                          onPressed: () async {

                            if(searchCtrl.text.isNotEmpty){
                              List<College> clgs = await CollegeServices()
                                  .searchColleges(
                                searchText: searchCtrl.text.trim(),
                                streams: controller.selectedStreams.toList(),
                                states: controller.selectedStates.toList(),
                                cities: controller.selectedCities.toList(),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchRes(clgs),
                                ),
                              );
                            }

                          },
                          child: Text(
                            "Search",
                            style: TextStyle(color: theme.filterSelectedColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              buildStreamSection("Search by Streams", streams),

              SizedBox(height: 24,),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: theme.backgroundGradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: buildGridSection(
                  "Search by States",
                  states,
                  controller.selectedStates,
                  controller.toggleStates,
                  isGreyBox: true,
                ),
              ),
              SizedBox(height: 24),

              // Display states only after a country is selected
              Obx(() {
                if (controller.selectedStates.isNotEmpty) {
                  // Clear the displayed states list
                  displayedCities.clear();
                  // Loop through all selected countries and add their states to displayedStates
                  for (String state in controller.selectedStates) {
                    displayedCities.addAll(stateCities[state] ?? []);
                  }
                  // Ensure unique states are displayed
                  displayedCities = RxList<String>(
                    displayedCities.toSet().toList(),
                  );
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: theme.backgroundGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: buildGridSection(
                      "Search by Cities",
                      displayedCities,
                      controller.selectedCities,
                      controller.toggleCities,
                      isGreyBox: true,
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),

              SizedBox(height: 24),
            ],
          ),
        ),

      );
    });
  }

  Widget buildGridSection(
    String title,
    List<String> items,
    RxSet<String> selectedItems,
    Function(String) onTap, {
    required bool isGreyBox,
  }) {
    final theme = ThemeController.to.currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Obx(
          () => GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children:
                items.map((item) {
                  final isSelected = selectedItems.contains(item);
                  return GestureDetector(
                    onTap: () => onTap(item),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            isSelected
                                ? Border.all(
                                  color: theme.filterSelectedColor,
                                  width: 2,
                                )
                                : null,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 1, vertical: 8),
                      child: Center(
                        child: Text(
                          item,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildStreamSection(String title, List<String> items) {
    final theme = ThemeController.to.currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  items.map((item) {
                    final isSelected = controller.selectedStreams.contains(
                      item,
                    );
                    return GestureDetector(
                      onTap: () => controller.toggleStream(item),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? theme.filterSelectedColor
                                  : Colors.transparent,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
