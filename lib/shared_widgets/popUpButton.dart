import 'package:criminal_alert_admin/screen_widgets/add_police_tips_screen.dart';
import 'package:criminal_alert_admin/services/auth.dart';
import 'package:flutter/material.dart';

AuthServices _authServices = AuthServices();
String logout = 'logout';
String post_tips = 'post_tips';

Widget popupMenuButton(BuildContext context){
  return PopupMenuButton( 
    color: Colors.white,
    icon: Icon(Icons.more_vert, color: Colors.white,),
    itemBuilder: (context)=> <PopupMenuEntry<String>>[
      PopupMenuItem(
        value: logout,
        child: Text('Logout',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      PopupMenuItem(
        value: post_tips,
        child: Text('Add Tips',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
    ],
    onSelected: (val) async{
      if(val == logout){
        await _authServices.signOut();
        return;
      }
      else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> AddPoliceTips(),
        ));
      }
    },
  );
}


