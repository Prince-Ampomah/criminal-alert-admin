import 'dart:async';
import 'package:criminal_alert_admin/ImageAsMarker/marker_Image.dart';
import 'package:criminal_alert_admin/google_map/popUpButton.dart';
import 'package:criminal_alert_admin/services/database.dart';
import 'package:criminal_alert_admin/showSnackBar/snackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //Declaration of Map Variables
  StreamSubscription _locationSubscription;
  Location userLocation = Location();
  MapType _mapType = MapType.normal;
  GoogleMapController _controller;

  static LatLng initialPosition = LatLng(37.42796133580664, -122.085749655962);
  CameraPosition initialCameraPosition = CameraPosition(
    target: initialPosition,
    zoom: 14.4746,
  );
  static LocationData currentPoliceLoc;
  static LatLng  cameraAnimateTarget = LatLng(currentPoliceLoc.latitude,
      currentPoliceLoc.longitude);


  static Set<Marker> marker = Set<Marker>();
  static Set<Circle> circle = Set<Circle>();
  static Set<Polyline> polyline = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double _originLatitude = 6.8084983, _originLongitude = -1.424405;
  double _destLatitude = 6.7443465, _destLongitude = -1.5653409;

 List<LatLng> routes = [LatLng(6.8084983, -1.424405), LatLng(6.7443465, -1.5653409)];

  static String googleAPIKey = 'AIzaSyDrAUtyy_qwqz7g5K9VoLAP_ZCxIeEo6og';
//  GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey: googleAPIKey);

  // Initialize VictimLocation Class
  VictimLocation queryLocation = VictimLocation(
      polyline: polyline,
      circle: circle,
      marker: marker);

  void updatePoliceMarker(Uint8List imageAsMarker, LocationData newLocationData)
  {
    LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
    setState(() {
      marker.add(Marker(
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
    setState(() {
      _controller = controller;
      queryLocation.queryVictimLocation();
    });

    mapStyle();

    try {
      var markerData = await getImageAsMarker(context);
      var location = await userLocation.getLocation();
      updatePoliceMarker(markerData, location);

//      if (_locationSubscription != null) {
//        _locationSubscription.cancel();
//      }

      _locationSubscription = userLocation.onLocationChanged
          .listen((LocationData currentPoliceLocation) {

            currentPoliceLoc = currentPoliceLocation;

        if (_controller != null) {
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: cameraAnimateTarget,
            zoom: 11.50,
          )));

          updatePoliceMarker(markerData, currentPoliceLoc);

          //add and remove police marker as the marker moves
          marker.removeWhere((m) => m.markerId.value == 'police_marker');
          marker.add(Marker(
            markerId: MarkerId('police_marker'),
            position: LatLng(currentPoliceLoc.latitude,
                currentPoliceLoc.longitude),
            infoWindow: InfoWindow(
                title: 'Police Current Locaton',
                snippet: "400KM Away from victim"),
            icon: BitmapDescriptor.fromBytes(markerData),
          ));
        }
      });
    } catch (e) {
      print(e.toString());
    }

  }

  void setMapStyle(String mapstyle){
    _controller.setMapStyle(mapstyle);
  }

  Future<String> getMapStyle(String path) async {
    return await rootBundle.loadString(path);
  }

  //Map style Change
  mapStyle(){
    getMapStyle('assets/mapstyle/nightmapstyle.json').then(setMapStyle);
  }

  void _showMapTypeSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
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
                    Text(
                      'MAP TYPE',
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
                              onTap: () {
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
                                      image:
                                          AssetImage('assets/normal_type.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/hybrid_type.jpeg'),
                                    fit: BoxFit.cover),
                              ),
                              child: InkWell(
                                onTap: () {
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
                                    fit: BoxFit.cover),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _mapType = MapType.terrain;
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
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

 /* addPolyLine(){
    Polyline(
      polylineId: PolylineId('poly'),
      points: polylineCoordinates,
      color: Colors.blue,
      visible: true
    );
    setState(() {

    });
  }

  getPolyline() async{
   PolylineResult result = await polylinePoints.
    getRouteBetweenCoordinates(
        'AIzaSyDrAUtyy_qwqz7g5K9VoLAP_ZCxIeEo6og',
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
//        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]
    );

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolyLine();
  }*/



  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crime Alert Admin'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
        popupMenuButton(context),
        ],),
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            mapType: _mapType,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            markers: marker,
            circles: circle,
            polylines: polyline,
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
        ],
      ),
    );
  }
}
