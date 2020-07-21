import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PoliceTipsDetails extends StatefulWidget {

  final DocumentSnapshot snapshot;
  PoliceTipsDetails({this.snapshot});

  @override
  _PoliceTipsDetailsState createState() => _PoliceTipsDetailsState();
}

class _PoliceTipsDetailsState extends State<PoliceTipsDetails> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )
      ),
      child: Container(
          height: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        )
                    ),
                    child: Center(child: Text(widget.snapshot.data['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),))
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
                  child: Container(
                      child: Text(widget.snapshot.data['content'],
                        style: TextStyle(
                          fontSize: 15.0,
                          wordSpacing: 0.30,
                        ),)
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
