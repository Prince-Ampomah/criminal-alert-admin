import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:criminal_alert_admin/ImageAsMarker/marker_Image.dart';
import 'package:criminal_alert_admin/InternetConnection/internetConnectivity.dart';
import 'package:criminal_alert_admin/showSnackBar/snackBar.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Declaration of Map Variables
  static LatLng initialPosition = LatLng(37.42796133580664, -122.085749655962);
  StreamSubscription _locationSubscription;
  Location userLocation = Location();
  MapType _mapType = MapType.normal;
  GoogleMapController _controller;

  Set<Marker> _marker = Set<Marker>();
  Set<Circle> _circle = Set<Circle>();

//  Geoflutterfire geo = Geoflutterfire();


  CameraPosition initialCameraPosition = CameraPosition(
    target: initialPosition,
    zoom: 14.4746,
  );

  void updatePoliceMarker(Uint8List imageAsMarker, LocationData newLocationData) {
    LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
    setState(() {
      _marker.add(
          Marker(
        markerId: MarkerId('police_marker'),
        position: latLng,
        draggable: false,
        infoWindow: InfoWindow(
            title: 'Police Current Location',
            snippet: '400KM away from victim'),
        flat: false,
        icon: BitmapDescriptor.fromBytes(imageAsMarker),
//        zIndex: 2.0,
//       rotation: newLocationData.heading,
//       anchor: Offset(0.5, 0.5),
      ));
    });
  }

  void onMapCreated(GoogleMapController controller) async {

      setState(() async{

        _controller = controller;

        startQuery();

        try {
          var markerData = await getImageAsMarker(context);
          var location = await userLocation.getLocation();
          updatePoliceMarker(markerData,location);

          if (_locationSubscription != null) {
            _locationSubscription.cancel();
          }

          _locationSubscription = userLocation.onLocationChanged.listen((userCurrentLocation) {
            if (_controller != null) {
              _controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(userCurrentLocation.latitude, userCurrentLocation.longitude),
                zoom: 13,
              )));

              updatePoliceMarker(markerData, userCurrentLocation);

              //add and remove police marker as the marker moves
              _marker.removeWhere((m)=> m.markerId.value == 'police_marker');
              _marker.add(Marker(
                markerId: MarkerId('police_marker'),
                position: LatLng(userCurrentLocation.latitude, userCurrentLocation.longitude),
                infoWindow: InfoWindow(
                    title: 'Police Current Location',
                    snippet: '400KM away from victim'),
                icon: BitmapDescriptor.fromBytes(markerData),
              ));

            }
          });

        }catch (e) {
          print(e.toString());
        }
      });

    


  }


  void _showMapTypeSheet() {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          backgroundColor: Colors.white,
          context: context,
          builder: (context) {
           return SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
               child: Center(
                 child: Column(
                   children: <Widget>[
                     Text('MAP TYPE',
                     style: TextStyle(
                       fontWeight: FontWeight.w700,
                     ),
                     ),
                     SizedBox(height: 25),
                     Column(
                       children: <Widget>[
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             InkWell(
                               onTap: (){
                                 setState(() {
                                   _mapType = MapType.normal;
                                   Navigator.of(context).pop();
                                 });
                               },
                               child: Container(
                                 height: 60.0,
                                 width: 60.0,
                                 decoration: BoxDecoration(
                                   image: DecorationImage(
                                     image: AssetImage('assets/normal_type.png'),
                                     fit: BoxFit.cover
                                   ),
                                 ),
                               ),
                             ),
                             Container(
                               height: 60.0,
                               width: 60.0,
                               decoration: BoxDecoration(
                                 image: DecorationImage(
                                   image: AssetImage('assets/hybrid_type.jpeg'),
                                   fit: BoxFit.cover
                                 ),
                               ),
                               child: InkWell(
                                 onTap: (){
                                   setState(() {
                                     _mapType = MapType.hybrid;
                                     Navigator.of(context).pop();
                                   });
                                 },
                               ),
                             ),
                             Container(
                               height: 60.0,
                               width: 60.0,
                               decoration: BoxDecoration(
                                 image: DecorationImage(
                                   image: AssetImage('assets/terrain.jpeg'),
                                   fit: BoxFit.cover
                                 ),
                               ),
                               child: InkWell(
                                 onTap: (){
                                   setState(() {
                                     _mapType = MapType.terrain;
                                     Navigator.of(context).pop();
                                   });
                                 },
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 5.0,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             Text('Normal'),
                             Text('Hybrid'),
                             Text('Terrain')
                           ],
                         )
                       ],

                     ),

                   ],
                 ),
               ),
             ),
           );
          });
    }


  void startQuery() async{

    CollectionReference locationCollection =
    Firestore.instance.collection('Location');

    locationCollection.snapshots().forEach((QuerySnapshot querySnapshot){
      querySnapshot.documents.forEach((snapshot){
        GeoPoint geoPoint = snapshot.data['userLocation']['geopoint'];
        LatLng latLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
        print("SnapShot Query $latLng");
        _marker.add(Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
              title: 'Victim Marker',
              snippet: 'Victim Location'),
        ));
        _circle.add(Circle(
            circleId: CircleId('driving_pin_circle'),
            fillColor: Colors.green,
            strokeColor: Colors.red,
            strokeWidth: 10,
            center: latLng,
            zIndex: 1,
            radius: 10
            ));

      });

    });

  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  mapType: _mapType,
                  onMapCreated: onMapCreated,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  markers: _marker,
                  circles: _circle,
//                  markers: Set.of((marker != null) ? [marker] : [])
            ),
            Padding(
              padding: EdgeInsets.only(top: 80, right: 8.5),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: _showMapTypeSheet,
                  child: Icon(Icons.map),
                  elevation: 5.0,
                  tooltip: 'Map Type',
                ),
              ),
            ),
//            Padding(
//              padding: EdgeInsets.only(top: 80, right: 8.5),
//              child: Align(
//                alignment: Alignment.topRight,
//                child: FloatingActionButton(
//                  onPressed: startQuery,
//                  child: Icon(Icons.add),
//                  elevation: 5.0,
//                  tooltip: 'Select Map Type',
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
