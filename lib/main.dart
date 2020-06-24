
import 'package:criminal_alert_admin/services/auth.dart';
import 'package:criminal_alert_admin/wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
          value: AuthServices().user,
          child: MaterialApp(
          title: 'Criminal Alert Admin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
      primarySwatch: Colors.blue,
          ),
          home: Wrapper(),
        ),
    );
  }
}
