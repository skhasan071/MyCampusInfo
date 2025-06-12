import 'dart:convert';
import 'package:my_campus_info/model/placement.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:my_campus_info/model/college.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;

class CompareColleges extends StatefulWidget {
  final String collegeImage;
  final College clg;
  final College college;
  final String collegeId;
  final String collegeName;
  final String ranking;
  final String feeRange;
  final String state;
  final College firstCollege;
  final College secondCollege;

  const CompareColleges({
    super.key,
    required this.clg,
    required this.college,
    required this.collegeName,
    required this.collegeId,
    required this.ranking,
    required this.feeRange,
    required this.state,
    required this.collegeImage,
    required this.firstCollege,
    required this.secondCollege,
  });
  @override
  State<CompareColleges> createState() => _CompareCollegesState();
}

class _CompareCollegesState extends State<CompareColleges> {
  Placement? placement1;
  Placement? placement2;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlacementData();
  }

  Future<void> fetchPlacementData() async {
    try {
      final response1 = await http.get(
        Uri.parse(
          'https://tc-ca-server.onrender.com/api/colleges/placement/${widget.firstCollege.id}',
        ),
      );

      final response2 = await http.get(
        Uri.parse(
          'https://tc-ca-server.onrender.com/api/colleges/placement/${widget.secondCollege.id}',
        ),
      );

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final data1 = jsonDecode(response1.body);
        final data2 = jsonDecode(response2.body);

        setState(() {
          placement1 = data1.isNotEmpty ? Placement.fromJson(data1[0]) : null;
          placement2 = data2.isNotEmpty ? Placement.fromJson(data2[0]) : null;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Find the Best Fit',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Compare. Decide. Succeed!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Text(
                'Compare Colleges',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.filterSelectedColor,
                  fontSize: 33,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Side-by-side comparison to find your best fit.',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: _collegeLogoWithName(
                      widget.firstCollege.name,
                      widget.clg.image,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: _collegeLogoWithName(
                      widget.secondCollege.name,
                      widget.clg.image,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _infoRow('Location', [
                widget.firstCollege.state,
                widget.secondCollege.state,
              ]),
              _infoRow('Fees', [
                widget.firstCollege.feeRange,
                widget.secondCollege.feeRange,
              ]),
              _infoRow('NIRF Ranking', [
                widget.firstCollege.ranking.toString(),
                widget.secondCollege.ranking.toString(),
              ]),
              _infoRow('Placement Rate', [
                placement1?.placementRate ?? 'Loading...',
                placement2?.placementRate ?? 'Loading...',
              ]),

              _infoRow('No. of Companies Visited', [
                placement1?.numberOfCompanyVisited ?? 'Loading...',
                placement2?.numberOfCompanyVisited ?? 'Loading...',
              ]),

              _infoRow('Top Recruiters', [
                placement1?.companiesVisited.join(', ') ?? 'Loading...',
                placement2?.companiesVisited.join(', ') ?? 'Loading...',
              ]),
              const Divider(color: Colors.black, thickness: 1),
            ],
          ),
        ),
      );
    });
  }

  Widget _collegeLogoWithName(String name, String imageUrl) {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(color: Colors.grey[300]),
          child:
              imageUrl.isNotEmpty
                  ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      );
                    },
                  )
                  : const Center(child: Icon(Icons.image, size: 40)),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 70,
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, List<String> values) {
    final theme = ThemeController.to.currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black, thickness: 1),
        const SizedBox(height: 18),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            '$label:',
            style: TextStyle(
              color: theme.filterSelectedColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Divider(color: Colors.black, thickness: 1),

        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(gradient: theme.backgroundGradient),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child:
                      isLoading
                          ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.filterSelectedColor,
                            ),
                          )
                          : Text(
                            values[0],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                ),
              ),
            ),
            Container(width: 1, color: Colors.black),

            Expanded(
              child: Container(
                decoration: BoxDecoration(gradient: theme.backgroundGradient),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child:
                      isLoading
                          ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.filterSelectedColor,
                            ),
                          )
                          : Text(
                            values[1],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
