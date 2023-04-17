import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_place_view.dart';
import '../providers/great_places_provider.dart';
import '../views/places_detail_view.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceView.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlacesProviders>(context, listen: false)
            .fetAndSetPlaces(),
        builder: (ctx, snapShot) => snapShot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : Consumer<GreatPlacesProviders>(
                child: const Center(
                  child: Text('No places yet. Start adding them'),
                ),
                builder: (ctx, greatPlaces, child) => greatPlaces.items.isEmpty
                    ? child as Widget
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctxx, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[index].image),
                          ),
                          title: Text(greatPlaces.items[index].title),
                          subtitle: Text(greatPlaces
                              .items[index].location!.address as String),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetail.routeName,
                              arguments: greatPlaces.items[index].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
