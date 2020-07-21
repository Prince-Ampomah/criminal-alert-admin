import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class VictimLocation {
  Set<Marker> marker = Set<Marker>();
  Set<Circle> circle = Set<Circle>();
  Set<Polyline> polyline = Set<Polyline>();
  Geolocator geoLocator = Geolocator();
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints;
  static String googleAPIKey = "AIzaSyDrAUtyy_qwqz7g5K9VoLAP_ZCxIeEo6og";


  VictimLocation({this.polyline, this.marker, this.circle});

  //Query Victim Location
  void queryVictimLocation() async {
    CollectionReference locationCollection =
        Firestore.instance.collection('Location');

    locationCollection.snapshots().forEach((QuerySnapshot querySnapshot) {
      querySnapshot.documents.forEach((snapshot) async {
        GeoPoint geoPoint = snapshot.data['userLocation']['geopoint'];
        LatLng victimLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
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
            title:
                '${place.administrativeArea},${place.subAdministrativeArea},${place.postalCode}',
            snippet: '${place.locality}, ${place.name}, ${place.isoCountryCode}',
          ),
        ));
/*        circle.add(Circle(
          circleId: CircleId(victimLocation.toString()),
          fillColor: Colors.red[300],
          strokeColor: Colors.red,
          strokeWidth: 3,
          center: victimLocation,
          zIndex: 1,
          radius: 300,
        ));*/
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

// Store Google Info in PoliceCollection
class PoliceUser{
  String uid;
  PoliceUser({this.uid});

CollectionReference policedetailsCollection = Firestore.instance.collection('PoliceCollection');

  Future<void> policeDetails(String providerId, String name , String email, String phoneNmber, String photoUrl) async{
    return await policedetailsCollection.document(uid).setData({
      'ProviderID' : providerId,
      'Name' : name,
      'Email' : email,
      'PhoneNumber': phoneNmber,
      'Photo' : photoUrl,
      'LastSeen': DateTime.now()
      },
      );

  }


}

class SavePoliceTips{

  CollectionReference policeTipsCollection = Firestore.instance.collection('PoliceTips');

  DateTime now = DateTime.now();


  Future<void> savePoliceTips(String title, String content) async{

    return await policeTipsCollection.document().setData({
      'title' : title,
      'content' : content,
      'time' : DateFormat.yMEd().add_jms().format(now)
    }
    );
  }

}

//Store device token in DeviceCollection
class SaveToken {
  String uid;
  SaveToken({this.uid});

  CollectionReference deviceTokenCollection = Firestore.instance.collection('DeviceToken');
  Future<void> saveDeviceToken(String token) async{
    return await deviceTokenCollection.document(uid).setData({'device_token': token});
  }
}
