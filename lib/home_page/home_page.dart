import 'package:criminal_alert_admin/shared_widgets/app_bar_widget.dart';
import 'package:criminal_alert_admin/shared_widgets/bottom_bar_screen_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int showScreens = 0;
  void onBottomTap(int index) => setState(() => showScreens = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: showScreens,
        type: BottomNavigationBarType.fixed ,
        backgroundColor: Colors.white,
        onTap: onBottomTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map, size: 27.0,),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 27.0,),
              title: Text('Chat')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 27.0,),
              title: Text('Tips')
          )
        ],
      ),
      body: ListScreens[showScreens],
    );
  }
}
