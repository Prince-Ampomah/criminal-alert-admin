
import 'package:flutter/material.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

void alertSnackBar() {
  var alertSnackbar = SnackBar(
    content: Text(
      'Police Alerted, Keep Calm!!',
      textAlign: TextAlign.center,
      style: TextStyle(letterSpacing: 0.5, fontWeight: FontWeight.w600),
    ),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
  scaffoldKey.currentState.showSnackBar(alertSnackbar);
}

void showConnectionSnackbar() {
  var connectionSnackbar = SnackBar(
    content: Text('Check Your Internet Connection.',
        textAlign: TextAlign.center, style: TextStyle(letterSpacing: 0.5)),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
  scaffoldKey.currentState.showSnackBar(connectionSnackbar);
}

void signInSnackBar() {
  var alertSnackbar = SnackBar(
    content: Text(
      'Sign In Failed',
      textAlign: TextAlign.center,
      style: TextStyle(letterSpacing: 0.5, fontWeight: FontWeight.w600),
    ),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
  scaffoldKey.currentState.showSnackBar(alertSnackbar);
}