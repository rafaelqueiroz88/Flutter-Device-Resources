import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

// default static locations
// lat: -22.7868465
// lon: -45.1864003

class MapView extends StatefulWidget {
  final Location initialLocation;
  final bool isSelecting;

  const MapView({
    this.initialLocation = const Location(
      latitude: -22.7868465,
      longitude: -45.1864003,
    ),
    this.isSelecting = false,
    super.key,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _selectedLocation;

  void _selectLocation(LatLng location) {
    setState(() => _selectedLocation = location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_selectedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: _selectedLocation == null && widget.isSelecting
            ? ({})
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _selectedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                ),
              },
      ),
    );
  }
}
