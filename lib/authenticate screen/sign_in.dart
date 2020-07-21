import 'package:criminal_alert_admin/InternetConnection/internetConnectivity.dart';
import 'package:criminal_alert_admin/services/auth.dart';
import 'package:criminal_alert_admin/showSnackBar/snackBar.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthServices _authServices = AuthServices();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '\nCRIMINAL ALERT\n      (ADMIN)',
                      style: TextStyle(
                        color: Colors.grey[700],
                          fontSize: 26.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: <Widget>[
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.redAccent),
                          ))
                        : Center(child: Text('')),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: GoogleSignInButton(
                            onPressed: () async {
                              setState(() => isLoading = true);
                              dynamic result =
                                  await _authServices.loginWithGoogle();
                              if (result != null) {
                                print('Logged In');
                                setState(() => isLoading = false);
                              } else {
                                setState(() => isLoading = false);
                              }
                              DataConnectionStatus connectionStatus =
                                  await checkInternetConnection();
                              if (connectionStatus ==
                                  DataConnectionStatus.disconnected) {
                                FlutterToast.showToast(
                                    msg: "network error!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            darkMode: true,
                            splashColor: Colors.redAccent,
                            borderRadius: 5.0)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
