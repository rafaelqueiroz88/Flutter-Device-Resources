import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';
import '../views/map_view.dart';

class LocationInput extends StatefulWidget {
  final Function? onSelectPlace;
  const LocationInput(this.onSelectPlace, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) async {
    final staticMapPreviewUrl = LocationHelper.generatedLocationPreview(
      latitude: lat,
      longitude: lng,
    );
    setState(() => _previewImageUrl = staticMapPreviewUrl);
  }

  Future<void> _getCurrentLocation() async {
    try {
      final localData = await Location().getLocation();
      _showPreview(localData.latitude!, localData.longitude!);
      final staticMapPreviewUrl = LocationHelper.generatedLocationPreview(
        latitude: double.parse(localData.latitude.toString()),
        longitude: double.parse(localData.longitude.toString()),
      );
      setState(() => _previewImageUrl = staticMapPreviewUrl);
      widget.onSelectPlace!(localData.latitude, localData.longitude);
    } catch (err) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (
          ctx,
        ) =>
            const MapView(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) return;

    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace!(
        selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text(
                  'No Locations yet',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _getCurrentLocation(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: const [
                    Text('Current Location'),
                    Icon(Icons.location_on),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () => _selectOnMap(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: const [
                    Text('Select Location'),
                    Icon(Icons.map),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
