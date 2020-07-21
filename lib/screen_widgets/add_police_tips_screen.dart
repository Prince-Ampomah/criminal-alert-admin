
import 'package:criminal_alert_admin/services/database.dart';
import 'package:criminal_alert_admin/shared_widgets/constants.dart';
import 'package:criminal_alert_admin/showSnackBar/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPoliceTips extends StatefulWidget {
  @override
  _AddPoliceTipsState createState() => _AddPoliceTipsState();
}

class _AddPoliceTipsState extends State<AddPoliceTips> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController policeTipsContent = TextEditingController();
  final TextEditingController policeTipsTitle = TextEditingController();

  postTips() {
    if (formKey.currentState.validate()) {
      SavePoliceTips()
          .savePoliceTips(policeTipsTitle.text, policeTipsContent.text);
      FlutterToast.showToast(
          msg: "Tips Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
      policeTipsContent.clear();
      policeTipsTitle.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Criminal Alert'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          validator: (val) {
                            return val.isEmpty ? 'Field is empty' : null;
                          },
                          controller: policeTipsTitle,
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.black,
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Police Tips (title)')),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                          validator: (val) {
                            return val.isEmpty ? 'Field is empty' : null;
                          },
                          controller: policeTipsContent,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          cursorColor: Colors.black,
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Add Police Tips'))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: postTips,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'Post Tips',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
