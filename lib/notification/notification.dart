import 'package:criminal_alert_admin/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotification{
  String uid;
  SendNotification({this.uid});

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future sendNotification() async{
    firebaseMessaging.getToken().then((token)async{
      print('Phone Token: $token');
     return SaveToken(uid: uid).saveDeviceToken(token);
    });

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async{
    //     print("onMessage: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async{
    //     print("onResume: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async{
    //     print("onLaunch: $message");
    //   },
    // );

  }
}