import 'dart:convert';
import 'package:http/http.dart' as http;

const apiPrefix = 'https://maps.googleapis.com/maps/api';
const googleApiKey = 'your-key-here';

class LocationHelper {
  static String generatedLocationPreview(
      {required double latitude, required double longitude}) {
    return '$apiPrefix/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getAddressByCoordinates(
      double latitude, double longitude) async {
    final String url =
        '$apiPrefix/geocode/json?latlng=$latitude,$longitude&key=$googleApiKey';
    final response = await http.get(Uri.parse(url));

    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}

/*
https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap
&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318
&markers=color:red%7Clabel:C%7C40.718217,-73.998284
&key=YOUR_API_KEY&signature=YOUR_SIGNATURE

Não sei onde, como ou o que é esse signature, mas aparentemente não é obrigatório.
Provavelmente é para algum programa de afiliados
*/