import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/great_places_provider.dart';
import './views/places_list_view.dart';
import './views/add_place_view.dart';
import './views/places_detail_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlacesProviders(),
      child: MaterialApp(
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: const PlacesListView(),
        routes: {
          AddPlaceView.routeName: (ctx) => const AddPlaceView(),
          PlaceDetail.routeName: (ctx) => const PlaceDetail(),
        },
      ),
    );
  }
}
