import 'package:my_campus_info/services/user_services.dart'; // Ensure this import
import 'package:my_campus_info/view/home_page.dart';
import 'package:my_campus_info/view/profiles/choice_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/ui_helper.dart';
import '../../main.dart';
import '../../model/user.dart'; // adjust the path as needed

class CompleteProfilePage extends StatefulWidget {
  final bool isEditing;
  const CompleteProfilePage({super.key, this.isEditing = false});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  var profile = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    getFields();
  }

  final List<String> studyingItems = [
    'SSC',
    'HSC',
    'Engineering College',
    'Management College',
    'Business School',
    'Arts & Humanities College',
    'Law School',
    'Medical College',
    'Design Institute',
  ];

  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  Map<String, List<String>> cities = {
    'Andhra Pradesh': ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Nellore', 'Tirupati'],
    'Arunachal Pradesh': ['Itanagar', 'Tawang', 'Pasighat', 'Ziro', 'Bomdila'],
    'Assam': ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat', 'Tezpur'],
    'Bihar': ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Darbhanga'],
    'Chhattisgarh': ['Raipur', 'Bhilai', 'Bilaspur', 'Korba', 'Durg'],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar'],
    'Haryana': ['Faridabad', 'Gurgaon', 'Panipat', 'Ambala', 'Hisar'],
    'Himachal Pradesh': ['Shimla', 'Manali', 'Dharamshala', 'Solan', 'Mandi'],
    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar'],
    'Karnataka': ['Bangalore', 'Mysuru', 'Mangaluru', 'Hubli-Dharwad', 'Belagavi'],
    'Kerala': ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur', 'Alappuzha'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Jabalpur', 'Gwalior', 'Ujjain'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad'],
    'Manipur': ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur', 'Ukhrul'],
    'Meghalaya': ['Shillong', 'Tura', 'Nongstoin', 'Jowai', 'Baghmara'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Champhai', 'Serchhip', 'Kolasib'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang', 'Wokha'],
    'Odisha': ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur'],
    'Punjab': ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Bikaner'],
    'Sikkim': ['Gangtok', 'Namchi', 'Gyalshing', 'Mangan', 'Rangpo'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'],
    'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Khammam', 'Karimnagar'],
    'Tripura': ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailasahar', 'Belonia'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Allahabad'],
    'Uttarakhand': ['Dehradun', 'Haridwar', 'Roorkee', 'Haldwani', 'Nainital'],
    'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Asansol', 'Siliguri'],
  };

  String? studyingIn;
  String? state;
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.isEditing
                      ? "Update your Profile"
                      : "Complete your Profile",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isEditing
                      ? "Update your details below."
                      : "Complete your details below.",
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 24),

                const Text("Enter your name *"),
                const SizedBox(height: 8),
                UiHelper.getTextField(hint: "Name", controller: nameController),
                const SizedBox(height: 16),

                const Text("Enter your email *"),
                const SizedBox(height: 8),
                UiHelper.getTextField(
                  hint: "Email",
                  controller: emailController,
                  pre: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),

                const Text("Enter your mobile number *"),
                const SizedBox(height: 8),
                UiHelper.getTextField(
                  hint: "Mobile (include +91)",
                  controller: mobileController,
                  pre: const Icon(Icons.phone_outlined),
                  inputFormatters: [LengthLimitingTextInputFormatter(13)],
                ),
                const SizedBox(height: 16),

                buildDropdown(
                  "Studying in",
                  (val) => studyingIn = val,
                  studyingItems,
                  profile.profile.value!.studyingIn,
                ),
                const SizedBox(height: 16),
                buildDropdown(
                  "State",
                      (val) {
                    setState(() {
                      state = val;
                      city = (val != null && cities.containsKey(val)) ? cities[val]!.first : null;
                    });
                  },
                  states,
                  state,
                ),
                const SizedBox(height: 16),
                buildDropdown(
                  "City You Live In",
                      (val) => city = val,
                  state != null && cities.containsKey(state!)
                      ? cities[state!]!
                      : [],
                  city,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UiHelper.getSecondaryBtn(
                      title: "Cancel",
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 12),
                    UiHelper.getPrimaryBtn(
                      title: widget.isEditing ? "Update" : "Next",
                      callback: () async {
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
                        String phNo = mobileController.text.trim();

                        studyingIn ??= studyingItems[0];
                        state ??= states[0];
                        city ??= cities[state!]![0] ?? '';

                        if (phNo.length != 13) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter a 12-digit mobile number",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        } else if (!phNo.contains("+91")) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter valid Mobile Number including +91",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Proceed with updating profile
                        if (name.isNotEmpty &&
                            email.isNotEmpty &&
                            phNo.isNotEmpty &&
                            studyingIn != null &&
                            state != null &&
                            city != null) {
                          if (profile.userToken.value == '') {
                            profile.userToken.value = (await getToken()) ?? '';
                          }

                          Student? data =
                              await StudentService.addOrUpdateStudent(
                                token: profile.userToken.value,
                                mobileNumber: phNo,
                                studyingIn: studyingIn!,
                                city: city!,
                                state: state!,
                                name: name,
                                email: email,
                              );

                          if (data != null) {
                            print("Received: ${profile.userToken.value}");
                            if (widget.isEditing) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Profile Updated Successfully!",
                                  ),
                                  backgroundColor: Colors.black,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          HomePage(profile.userToken.value),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const CoursePreferencesPage(
                                        isFlow: true,
                                      ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Something Went Wrong, Retry...",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        } else {
                          if (name.isEmpty) {
                            showSnack(context, "Name is required");
                            return;
                          }
                          if (email.isEmpty) {
                            showSnack(context, "Email is required");
                            return;
                          }

                          if (phNo.isEmpty) {
                            showSnack(context, "Mobile number is required");
                            return;
                          }

                          if (studyingIn == null || studyingIn!.isEmpty) {
                            showSnack(
                              context,
                              "Please select what you are studying",
                            );
                            return;
                          }

                          if (state == null || state!.isEmpty) {
                            showSnack(context, "Please select your state");
                            return;
                          }

                          if (city == null || city!.isEmpty) {
                            showSnack(context, "Please select your city");
                            return;
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDropdown(
      String label,
      Function(String?) onChanged,
      List<String> dropdownItems,
      String? selectedValue,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue ?? dropdownItems.first,
          items: dropdownItems
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            onChanged(val);
            setState(() {}); // Update the UI when state changes
          },
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void getFields() {
    Student pfp = profile.profile.value!;
    nameController.text = pfp.name ?? '';
    emailController.text = pfp.email ?? '';
    mobileController.text = pfp.mobileNumber ?? "";
    studyingIn = pfp.studyingIn ?? studyingItems[0];
    state = pfp.state ?? states[0];
    if (state != null && cities.containsKey(state!)) {
      city = pfp.city ?? cities[state!]!.first;
    } else {
      city = null;
    }
  }
}
