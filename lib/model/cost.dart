class CostModel {
  final String collegeId;
  final String address;
  final CostOfLiving costOfLiving;
  final NearbyPlaces nearbyPlaces;

  CostModel({
    required this.collegeId,
    required this.address,
    required this.costOfLiving,
    required this.nearbyPlaces,
  });

  factory CostModel.fromJson(Map<String, dynamic> json) {
    return CostModel(
      collegeId: json['collegeId'] ?? 'Unknown',
      address: json['address'] ?? 'Not provided',
      costOfLiving: CostOfLiving.fromJson(json['costOfLiving'] ?? {}),
      nearbyPlaces: NearbyPlaces.fromJson(json['nearbyPlaces'] ?? {}),
    );
  }
}

class CostOfLiving {
  final int monthlyRent;
  final int monthlyUtilities;
  final int monthlyTransport;
  final int monthlyGroceries;

  CostOfLiving({
    required this.monthlyRent,
    required this.monthlyUtilities,
    required this.monthlyTransport,
    required this.monthlyGroceries,
  });

  factory CostOfLiving.fromJson(Map<String, dynamic> json) {
    return CostOfLiving(
      monthlyRent: int.tryParse(json['monthlyRent'].toString()) ?? 0,
      monthlyUtilities: int.tryParse(json['monthlyUtilities'].toString()) ?? 0,
      monthlyTransport: int.tryParse(json['monthlyTransport'].toString()) ?? 0,
      monthlyGroceries: int.tryParse(json['monthlyGroceries'].toString()) ?? 0,
    );
  }
}

class NearbyPlaces {
  final Place restaurants;
  final Place cafes;
  final Place shopping;
  final PublicTransport publicTransport;

  NearbyPlaces({
    required this.restaurants,
    required this.cafes,
    required this.shopping,
    required this.publicTransport,
  });

  factory NearbyPlaces.fromJson(Map<String, dynamic> json) {
    return NearbyPlaces(
      restaurants: Place.fromJson(json['restaurants'] ?? {}),
      cafes: Place.fromJson(json['cafes'] ?? {}),
      shopping: Place.fromJson(json['shopping'] ?? {}),
      publicTransport: PublicTransport.fromJson(json['publicTransport'] ?? {}),
    );
  }
}

class Place {
  final int count;
  final int withinMiles;

  Place({required this.count, required this.withinMiles});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      count: int.tryParse(json['count'].toString()) ?? 0,
      withinMiles: int.tryParse(json['withinMiles'].toString()) ?? 0,
    );
  }
}

class PublicTransport {
  final int stations;

  PublicTransport({required this.stations});

  factory PublicTransport.fromJson(Map<String, dynamic> json) {
    return PublicTransport(
      stations: int.tryParse(json['stations'].toString()) ?? 0,
    );
  }
}
