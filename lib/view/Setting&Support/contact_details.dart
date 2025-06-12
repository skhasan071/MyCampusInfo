import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ContactDetailsPage extends StatelessWidget {
  const ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool isExpanded = false;
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Contact Talent Connect',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phone Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.phone, color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '7979863193',
                                style: TextStyle(
                                  color: theme.filterSelectedColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Email Row
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.email, color: Colors.black),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Contact-us@talentsconnectss.com',
                                style: TextStyle(
                                  color: theme.filterSelectedColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Location Row with expand/collapse (StatefulBuilder)
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Talent Connect- B BLOCK, first  FLOOR ROOM NO. 1  RUKMINI VENKATASWAMY REDDY ARCADE, ASHOKA LANE, GREEN GLEN LAYOUT, BELLANDUR, BANGALORE KARNATAKA - 560103',
                                        style: TextStyle(
                                          color: theme.filterSelectedColor,
                                          fontSize: 16,
                                        ),
                                        overflow:
                                            isExpanded
                                                ? TextOverflow.visible
                                                : TextOverflow.ellipsis,
                                        maxLines: isExpanded ? null : 2,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () => isExpanded = !isExpanded,
                                            );
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Send Us a Message:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Name Field
                  TextFormField(
                    controller: nameController,
                    cursorColor: theme.filterSelectedColor,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      labelStyle: TextStyle(color: Colors.black),

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.filterSelectedColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Name is required'
                                : null,
                  ),
                  const SizedBox(height: 10),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    cursorColor: theme.filterSelectedColor,
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.filterSelectedColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Email is required'
                                : null,
                  ),
                  const SizedBox(height: 10),

                  // Message Field
                  TextFormField(
                    controller: messageController,
                    maxLines: 4,
                    cursorColor: theme.filterSelectedColor,
                    decoration: InputDecoration(
                      labelText: 'Your Message',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.filterSelectedColor,
                          width: 2,
                        ),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Message is required'
                                : null,
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.filterSelectedColor,
                        foregroundColor: theme.filterTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Message sent successfully!',
                                style: TextStyle(color: theme.filterTextColor),
                              ),
                              backgroundColor: theme.filterTextColor,
                            ),
                          );
                          nameController.clear();
                          emailController.clear();
                          messageController.clear();
                        }
                      },
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
