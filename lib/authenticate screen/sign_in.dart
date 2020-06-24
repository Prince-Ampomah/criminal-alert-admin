import 'package:criminal_alert_admin/services/auth.dart';
import 'package:criminal_alert_admin/showSnackBar/snackBar.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        key: scaffoldKey,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               CircleAvatar(
        backgroundColor: Colors.white10,
        backgroundImage: AssetImage('assets/google.png'),
        radius: 30.0,
              ),
              SizedBox(height: 20,),
              Center(
        child: RaisedButton(
          onPressed: () async{
        dynamic result = await _authServices.loginWithGoogle();
          if(result != null){
            print('Logged In');
            }
          },
          child: Text('Sign In', style: TextStyle(color: Colors.white),),
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(5)),
          color: Colors.redAccent,
          elevation: 10.0,
        ),
              ),
              // SizedBox(height: 20.0,),
              // RaisedButton(
              //   onPressed: () async{
              //     await _authServices.signOut();
              // },
              //   child: Text('Sign out'),
              // ),
            ],
          ),
      ),
    );
  }
}

