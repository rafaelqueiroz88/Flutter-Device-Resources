import 'dart:io';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

import '../models/place.dart';

class GreatPlacesProviders with ChangeNotifier {
  List<Place> _list = [];

  List<Place> get items {
    return [..._list];
  }

  void addPlace(String title, File image, Location location) async {
    final address = await LocationHelper.getAddressByCoordinates(
        location.latitude, location.longitude);
    final extractedLocation = Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address);
    final place = Place(
      image: image,
      title: title,
      location: extractedLocation,
    );
    DBHelper.insert(
      'user_places',
      {
        'title': place.title,
        'image': place.image.path,
        'loc_lat': place.location!.latitude,
        'loc_lng': place.location!.longitude,
        'address': place.location!.address as String,
      },
    );
    final lastEntry = await DBHelper.getLastEntry();
    place.setId(lastEntry[0]['id']);
    _list.add(place);
    notifyListeners();
  }

  Place findById(int id) {
    return _list.firstWhere((place) => place.id == id);
  }

  Future<void> fetAndSetPlaces() async {
    final placesList = await DBHelper.getData('user_places');
    _list = placesList
        .map(
          (place) => Place(
            id: place['id'],
            location: Location(
              latitude: place['loc_lat'],
              longitude: place['loc_lng'],
              address: place['address'],
            ),
            image: File(place['image']),
            title: place['title'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
