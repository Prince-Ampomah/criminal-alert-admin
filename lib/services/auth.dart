import 'package:criminal_alert_admin/notification/notification.dart';
import 'package:criminal_alert_admin/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:criminal_alert_admin/model/User.dart';

class AuthServices{
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();


User _firebaseUserCustomized(FirebaseUser user){
  return user != null? User(uid: user.uid) : null;
}

Stream<User> get user{
  return _auth.onAuthStateChanged
  .map(_firebaseUserCustomized);
}

Future signInAnon() async{
  try{
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    _firebaseUserCustomized(user);
  }
  catch(error){
    print(error.toString());
  }
}

Future loginWithGoogle() async{
  try{
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
  if(googleAccount == null){
    print('Your google account is invalid, create one');
    return null;
  }
  GoogleSignInAuthentication googleSignInAuth= await googleAccount.authentication;
  AuthCredential authCredential = GoogleAuthProvider.
  getCredential(idToken: googleSignInAuth.idToken, accessToken: googleSignInAuth.accessToken);

  AuthResult result = await _auth.signInWithCredential(authCredential);
  FirebaseUser user = result.user;

  String userUID = user.uid;
  String name = user.displayName;
  String email = user.email;
  String phoneNumber = user.phoneNumber;
  String photoUrl = user.photoUrl;

  //Store UserDetails in Database
  await PoliceUser(uid: user.uid).policeDetails(userUID, name, email, phoneNumber, photoUrl);
  await SendNotification(uid: user.uid).sendNotification();
  _firebaseUserCustomized(user);

  }catch(error){
    print("Error: ${error.toString()}");
  }

}


Future signOut() async{
  try{
    await _auth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    print('signed out');
  }catch(error)
  {
    print(error.toString());
  }
}

}
