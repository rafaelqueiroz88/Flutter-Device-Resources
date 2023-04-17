import 'dart:io';

class Location {
  final double latitude;
  final double longitude;
  final String? address;

  const Location(
      {required this.latitude, required this.longitude, this.address});
}

class Place {
  int? id;
  final String title;
  final Location? location;
  final File image;

  Place({
    this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  void setId(int value) {
    id = value;
  }
}
