
import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void tipSnackBar() {
  var showSnackbar = SnackBar(
    content: Text(
      'Saved',
      textAlign: TextAlign.center,
      style: TextStyle(letterSpacing: 0.5, fontWeight: FontWeight.w600),
    ),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
  scaffoldKey.currentState.showSnackBar(showSnackbar);
}



