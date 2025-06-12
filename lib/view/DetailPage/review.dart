import 'package:my_campus_info/model/review.dart';
import 'package:my_campus_info/services/user_services.dart';
import 'package:my_campus_info/view/SignUpLogin/FirstPage.dart';
import 'package:my_campus_info/view/SignUpLogin/login.dart';
import 'package:my_campus_info/view_model/profile_controller.dart';
import 'package:my_campus_info/view_model/themeController.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../view_model/controller.dart';

class Reviews extends StatefulWidget {
  final String uid;

  const Reviews(this.uid, {super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isSnackBarActive = false;
  bool isSnackBarActionClicked = false;

  List<Review> _reviews = [];
  var pfp = Get.find<ProfileController>();
  var controller = Get.put(Controller());
  double averageRating = 0;
  List<int> percents = [0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();

    getReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Reviews & Ratings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),

      body: Obx(() {
        final theme = ThemeController.to.currentTheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStarRating(averageRating),

                      const SizedBox(height: 4),
                      const Text(
                        "Based on 2,456 reviews",
                        style: TextStyle(color: Colors.black, fontSize: 1),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.isGuestIn.value) {
                        if (isSnackBarActive)
                          return; // Prevent showing multiple snackbars

                        isSnackBarActive = true;
                        isSnackBarActionClicked = false;
                        final snackBar = SnackBar(
                          content: Text("Please Login First"),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.black,
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'Login',
                            textColor: Colors.blueAccent,
                            onPressed: () {
                              if (!isSnackBarActionClicked) {
                                isSnackBarActionClicked = true;

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              }
                            },
                          ),
                        );

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(snackBar).closed.then((_) {
                          isSnackBarActive = false;
                          isSnackBarActionClicked = false;
                        });
                      } else {
                        _showReviewDialog(context);
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.filterSelectedColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      "Write a Review",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 22),

              // Rating distribution
              _buildRatingBar("5 star", percents[0]),
              const SizedBox(height: 8),
              _buildRatingBar("4 star", percents[1]),
              const SizedBox(height: 8),
              _buildRatingBar("3 star", percents[2]),
              const SizedBox(height: 8),
              _buildRatingBar("2 star", percents[3]),
              const SizedBox(height: 8),
              _buildRatingBar("1 star", percents[4]),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 22),

              // Dynamic review list
              ..._reviews.map((review) {
                return _buildReviewItem(
                  review.name,
                  review.studentemail,
                  review.reviewtext,
                  review.rating.toDouble(),
                  "date",
                  review.likes,
                  10,
                );
              }).toList(),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     _showFilterPopup(context);
              //   },
              //   icon: const Icon(Icons.filter_list, size: 30),
              //   label: const Text(
              //     "Filter Reviews",
              //     style: TextStyle(fontSize: 19),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 9,
              //       vertical: 8,
              //     ),
              //     backgroundColor: theme.filterSelectedColor,
              //     foregroundColor: Colors.white,
              //     minimumSize: const Size.fromHeight(48),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.zero,
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStarRating(double rating, {double iconSize = 20}) {
    final theme = ThemeController.to.currentTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(Icons.star, color: theme.starColor, size: iconSize);
        } else if (rating > index) {
          return Icon(Icons.star_half, color: theme.starColor, size: iconSize);
        } else {
          return Icon(
            Icons.star_border,
            color: theme.starColor,
            size: iconSize,
          );
        }
      }),
    );
  }

  Widget _buildRatingBar(String label, int percent) {
    final theme = ThemeController.to.currentTheme;
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.filterSelectedColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "$percent%",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    String name,
    String role,
    String review,
    double rating,
    String date,
    int likes,
    int comments,
  ) {
    final theme = ThemeController.to.currentTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.selectedTextBackground,
            child: Icon(
              Icons.person,
              size: 36,
              color: theme.filterSelectedColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    _buildStarRating(rating, iconSize: 18),
                  ],
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF42A5F5),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Posted on $date",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    int selectedRating = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final theme = ThemeController.to.currentTheme;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Write a Review",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reviewController,
                    cursorColor: theme.filterSelectedColor,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write your thoughts here...",
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
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setModalState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: theme.starColor,
                          size: 35,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (reviewController.text.isNotEmpty &&
                            selectedRating > 0) {
                          Navigator.pop(context);
                          Review review = Review(
                            name: pfp.profile.value!.name!,
                            uid: widget.uid,
                            studentemail: pfp.profile.value!.email!,
                            rating: selectedRating,
                            reviewtext: reviewController.text.trim(),
                            likes: 0,
                          );
                          Review? rev = await StudentService().postReview(
                            review,
                          );

                          if (rev != null) {
                            _reviews.insert(0, rev);
                            setState(() {});
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please the review and select a star rating.",
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.filterSelectedColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  getReviews() async {
    _reviews = await StudentService().getReviews(widget.uid);

    averageRating = getAvgRating();
    percents = getPercents();

    setState(() {});
  }

  double getAvgRating() {
    int reviews = _reviews.length;

    int sum = 0;

    for (Review review in _reviews) {
      sum += review.rating;
    }

    setState(() {});

    return (sum / reviews);
  }

  List<int> getPercents() {
    List<int> percents = [0, 0, 0, 0, 0];
    List<int> per = [0, 0, 0, 0, 0];

    for (int i = 0; i < _reviews.length; i++) {
      switch (_reviews[i].rating) {
        case 5:
          per[0] += 1;
          break;
        case 4:
          per[1] += 1;
          break;
        case 3:
          per[2] += 1;
          break;
        case 2:
          per[3] += 1;
          break;
        case 1:
          per[4] += 1;
      }
    }

    for (int i = 0; i < per.length; i++) {
      percents[i] = ((per[i] * 100) / _reviews.length).toInt();
    }

    return percents;
  }
}
