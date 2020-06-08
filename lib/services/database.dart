
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class VictimLocation{

  Set<Marker> marker = Set<Marker>();
  Set<Circle> circle = Set<Circle>();
  Set<Polyline> polyline = Set<Polyline>();
  Geolocator geoLocator = Geolocator();
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints;
  static String googleAPIKey = "AIzaSyDrAUtyy_qwqz7g5K9VoLAP_ZCxIeEo6og";

//  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: googleAPIKey);

// static LatLng vicLoc;
//  GeoPoint _geoPoint = GeoPoint(vicLoc.longitude, vicLoc.longitude);
//  DocumentSnapshot _snapshot;


  VictimLocation({this.polyline, this.marker, this.circle});

  void queryVictimLocation() async {
    CollectionReference locationCollection =
    Firestore.instance.collection('Location');

    locationCollection.snapshots().forEach((QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((snapshot) async {
      GeoPoint geoPoint = snapshot.data['userLocation']['geopoint'];
     LatLng victimLocation = LatLng (geoPoint.latitude, geoPoint.longitude);
      print("SnapShot Query: $victimLocation");

        //Convert from LatLng to Address
        List<Placemark> p = await geoLocator.placemarkFromCoordinates(
            victimLocation.latitude, victimLocation.longitude);
        Placemark place = p[0];

        marker.add(Marker(
          markerId: MarkerId(victimLocation.toString()),
          position: victimLocation,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: '${place.name}, ${place.administrativeArea}',
            snippet: '${place.locality}, ${place.subAdministrativeArea}',
          ),
        ));
        circle.add(Circle(
          circleId: CircleId(victimLocation.toString()),
          fillColor: Colors.redAccent,
          strokeColor: Colors.red,
          strokeWidth: 3,
          center: victimLocation,
          zIndex: 1,
          radius: 300,
        ));

      });
    });
  }

  /*void setPolyLine() async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDrAUtyy_qwqz7g5K9VoLAP_ZCxIeEo6og",
        PointLatLng(6.8084983, -1.424405),
        PointLatLng(6.7443465, -1.5653409),
        travelMode: TravelMode.walking
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

        polyline.add(Polyline(
          polylineId: PolylineId('poly'),
          points: polyLineCoordinates,
          color: Colors.green,
          geodesic: true,
          startCap: Cap.buttCap
        ));


    }
  }*/

}

class SaveToken{

  CollectionReference deviceTokenCollection = Firestore.instance.collection('DeviceToken');

  Future saveDeviceToken(String token) {
    return deviceTokenCollection.document().setData({
        'device_token' : token
    });
  }

}