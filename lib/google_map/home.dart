import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 static  LatLng initialPosition = LatLng(37.42796133580664, -122.085749655962);
  Marker marker;
  Circle circle;
  StreamSubscription _locationSubscription;
  Location userLocation = Location();
  MapType _mapType = MapType.hybrid;
  GoogleMapController _controller;

  CameraPosition initialCameraPosition = CameraPosition(
      target: initialPosition,
      zoom: 14.4746,
  );

  /*Get marker that is the driving Pin*/
//  Future<Uint8List> getMarker() async {
//    ByteData byteData = await DefaultAssetBundle.of(context).load('assets/driving_pin.png');
//    return byteData.buffer.asUint8List();
//  }

 void updateCircleAndMarker(LocationData newLocationData){
   LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
   setState(() {
     marker = Marker(
       markerId: MarkerId('driving_pin'),
       position: latLng,
       draggable: false,
       flat: true,
       zIndex: 2.0,
       rotation: newLocationData.heading,
       anchor: Offset(0.5, 0.5),
       icon: BitmapDescriptor.defaultMarker
     );
     circle = Circle(
       circleId: CircleId('driving_pin_circle'),
       fillColor: Colors.blue.withAlpha(70),
       strokeColor: Colors.blue,
       strokeWidth: 3,
       center: latLng,
       zIndex: 1,
       radius: newLocationData.accuracy
     );
   });

 }


 void onMapCreated(GoogleMapController controller) async{
   _controller = controller;
   try{
      //  Uint8List imageData = await getMarker();
       var location = await userLocation.getLocation();
       updateCircleAndMarker(location);


       if(_locationSubscription != null){
         _locationSubscription.cancel();
       }

       _locationSubscription = userLocation.onLocationChanged.listen((currentUserLocation){
         if(_controller != null){
           _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
               target: LatLng(currentUserLocation.latitude, currentUserLocation.longitude),
               zoom: 15,
//               bearing: 192.8334901395799,
//               tilt: 59.440717697143555
           )));
           updateCircleAndMarker(currentUserLocation);
         }
       });

   }on PlatformException catch(e){
    if(e.code == 'PERMISSION_DENIED'){
      print('Permissin Denied');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Permissin Denied'),
      ));
    }
   }
 }

 @override
  void dispose() {

   if(_locationSubscription != null){
     _locationSubscription.cancel();
   }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Crimial Alert'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            mapType: MapType.hybrid, 
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            zoomGesturesEnabled: false,
            markers: Set.of((marker != null)? [marker] : []),
            // circles: Set.of((circle != null)? [circle] : []),
          )
        ],
      ),
    );
  }


}

