// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTrackingService {
//// without key find route

  Future<String> getPolylineWithoutKey(
      LatLng origin, LatLng destination) async {
    final String url =
        'https://router.project-osrm.org/route/v1/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=polyline';

    try {
      var response = await Dio().get(url);
      print("11111111111111111++++++++++++++++++++++++++++++++++");
      print(response.statusCode);
      print(response.data);
      print("__________________________________");
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          return routes[0]['geometry']; // Polyline string
        }
        throw 'No routes found';
      } else {
        throw 'Failed to fetch directions';
      }
    } catch (e) {
      rethrow;
    }
  }


  // find route using googlemap

  Future<String> getPolylineString(LatLng origin, LatLng destination) async {
    final String apiKey = "AIzaSyDxQfy4Rbp2wno25FBwr5xwHLqh9WRUg-w";
    // "AIzaSyCxjzqu6TtZl--tNK_tK6IhAdrTo2AwYc0";
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving&key=$apiKey';

    try {
      var response = await Dio().get(url);
      print(
          "++++++++++++++++++++++++++++++++++++++++++++))))))))))))))))))))))");
      print(response.statusCode);

      print("++++++++++++++++++++++++++++++++++++++++++++");
      print(response.data);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> routes = data['routes'];
        print(routes);
        print(
            "++++++++++++++++++++++++++++++++++++++++++++))))))))))))))))))))))");
        if (routes.isNotEmpty) {
          return routes[0]['overview_polyline']['points'];
        }
        throw 'No routes found';
      } else {
        throw 'Failed to fetch directions';
      }
    } catch (e) {
      rethrow;
    }
  }

}
