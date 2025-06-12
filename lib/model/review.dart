class Review {
  final String uid;
  final String name;
  final String studentemail;
  final int rating;
  final String reviewtext;
  final int likes;

  Review({
    required this.name,
    required this.uid,
    required this.studentemail,
    required this.rating,
    required this.reviewtext,
    required this.likes,
  });

  // Factory constructor to create a Review from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['studentName'] as String,
      uid: json['uid'] as String,
      studentemail: json['studentemail'] as String,
      rating: json['rating'] as int,
      reviewtext: json['reviewtext'] as String,
      likes: json['likes'] as int,
    );
  }

  // Convert Review instance to JSON for POST requests
  Map<String, dynamic> toJson() {
    return {
      'studentName': name,
      'uid': uid,
      'studentemail': studentemail,
      'rating': rating,
      'reviewtext': reviewtext,
      'likes': likes,
    };
  }
}