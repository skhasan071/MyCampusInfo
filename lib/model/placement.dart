class Placement {
  final String numberOfCompanyVisited;
  final String averagePackage;
  final String highestPackage;
  final String placementRate;
  final List<String> companiesVisited;
  final List<String> recentPlacements;
  final String fiveToTen;
  final String tenToFifteen;
  final String fifteenToTwenty;
  final String aboveTwenty;
  final List<BranchPlacement> branchWisePlacement;

  Placement({
    required this.numberOfCompanyVisited,
    required this.averagePackage,
    required this.highestPackage,
    required this.placementRate,
    required this.companiesVisited,
    required this.recentPlacements,
    required this.fiveToTen,
    required this.tenToFifteen,
    required this.fifteenToTwenty,
    required this.aboveTwenty,
    required this.branchWisePlacement,
  });

  // Factory method to create a Placement object from JSON data
  factory Placement.fromJson(Map<String, dynamic> json) {
    return Placement(
      numberOfCompanyVisited: json['numberOfCompanyVisited'] ?? '',
      averagePackage: json['averagePackage'] ?? '',
      highestPackage: json['highestPackage'] ?? '',
      placementRate: json['placementRate'] ?? '',
      companiesVisited: List<String>.from(json['companiesVisited'] ?? []),
      recentPlacements: List<String>.from(json['recentPlacements'] ?? []),
      fiveToTen: json['fiveToTen'] ?? '',
      tenToFifteen: json['tenToFifteen'] ?? '',
      fifteenToTwenty: json['fifteenToTwenty'] ?? '',
      aboveTwenty: json['aboveTwenty'] ?? '',
      branchWisePlacement:
          (json['branchWisePlacement'] as List<dynamic>? ?? [])
              .map((e) => BranchPlacement.fromJson(e))
              .toList(),
    );
  }

  // Method to convert Placement object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'numberOfCompanyVisited': numberOfCompanyVisited,
      'averagePackage': averagePackage,
      'highestPackage': highestPackage,
      'placementRate': placementRate,
      'companiesVisited': companiesVisited,
      'recentPlacements': recentPlacements,
      'fiveToTen': fiveToTen,
      'tenToFifteen': tenToFifteen,
      'fifteenToTwenty': fifteenToTwenty,
      'aboveTwenty': aboveTwenty,
      'branchWisePlacement':
          branchWisePlacement.map((e) => e.toJson()).toList(),
    };
  }
}

class BranchPlacement {
  final String branch;
  final String highestPackage;
  final String averagePackage;

  BranchPlacement({
    required this.branch,
    required this.highestPackage,
    required this.averagePackage,
  });

  factory BranchPlacement.fromJson(Map<String, dynamic> json) {
    return BranchPlacement(
      branch: json['branch'] ?? '',
      highestPackage: json['highestPackage'] ?? '',
      averagePackage: json['averagePackage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branch,
      'highestPackage': highestPackage,
      'averagePackage': averagePackage,
    };
  }
}
