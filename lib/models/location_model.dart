class LocationModel {
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });
}
