import 'package:criminal_alert_admin/authenticate%20screen/sign_in.dart';
import 'package:criminal_alert_admin/google_map/map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:criminal_alert_admin/model/User.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user.toString());

    if(user == null){
      return SignIn();
    }
    else{
      return HomePage();
    }
  }
}
