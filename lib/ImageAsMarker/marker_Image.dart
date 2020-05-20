import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';


// Get Image 
  Future<Uint8List> getImageAsMarker(BuildContext context) async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/driving_pin.png');
    return byteData.buffer.asUint8List();
  }
