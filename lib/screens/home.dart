import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/screens/all_orders.dart';
import 'package:tampee_admin/screens/dashboard.dart';
import 'package:tampee_admin/screens/settings.dart';
import 'package:tampee_admin/screens/vans.dart';
import 'package:tampee_admin/utils/common.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Dashboard(),
    AllOrders(),
    VansList(),
    Settings()
  ];

  Future<void> getToken() async {
    try {
      final response = await http.post(getTokenUrl,
          body: {"key": apiKey, "username": website_username});
      //response.add(utf8.encode(json.encode(itemInfo)));

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);

        print(responseJson);
        var preferences = await SharedPreferences.getInstance();
        preferences.setString(api_token, responseJson["api_token"]);
        // signIn() ;

      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
      }
    } catch (e) {
      print(e);
    }
  }

 


  Timer dataTimer;
  @override
  void initState() {
   // getToken();
   
    super.initState();
  }

  @override
  void dispose() {
    dataTimer.cancel();
    super.dispose();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: PageStorage(
        child: _children[_currentIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, 
        backgroundColor: primaryColor,// new
        currentIndex: _currentIndex,
        selectedItemColor: darkGreen,
        unselectedItemColor: lightestText, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Dashboard'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('Orders'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              title: Text('Vans')),
          new BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
