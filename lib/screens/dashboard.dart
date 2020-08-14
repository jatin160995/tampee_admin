import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/screens/van_detail.dart';
import 'package:tampee_admin/utils/common.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


bool isLoading = true;
dynamic dashboardLiveData ;

  Future<void> dashboardData() async {
     var preferences = await SharedPreferences.getInstance();
    print(dashboardUrl);
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
          dashboardUrl , body: {"token": preferences.getString(api_token)}
          );
    
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(preferences.getString(api_token));
        if (responseJson['status']) {
          setState(() {
            dashboardLiveData = responseJson;
            isLoading = false;
          });


          print(responseJson);
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Something went wrong");
        }
      } else {
        final responseJson = json.decode(response.body);
        showToast("Something went wrong");
        print(responseJson);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void initState() {
    dashboardData();
    super.initState();
  }






  final databaseReference = Firestore.instance;
  final Firestore _firestore = Firestore.instance;






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //drawer: DrawerMenu(),
        appBar: AppBar(centerTitle: true, title: Text("Dashboard")),
        body: isLoading ? Image.asset("assets/images/loading.gif") : ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 7.5, bottom: 7.5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Opacity(
                                  opacity: 0.15,
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: greenButton,
                                    size: 40,
                                  ))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Orders",
                                style: TextStyle(
                                    color: lightestText, fontSize: 13.5),
                              ),
                              Text(
                                dashboardLiveData['orders']['total'].toString(),
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dashboardLiveData['orders']['percentage'].toString()+"%",
                                style: TextStyle(
                                    color: greenButton,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(
                        top: 15, left: 7.5, right: 15, bottom: 7.5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Opacity(
                                  opacity: 0.15,
                                  child: Icon(
                                    Icons.credit_card,
                                    color: greenButton,
                                    size: 40,
                                  ))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Sales",
                                style: TextStyle(
                                    color: lightestText, fontSize: 13.5),
                              ),
                              Text(
                                dashboardLiveData['sales']['total'].toString(),
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dashboardLiveData['sales']['percentage'].toString()+"%",
                                style: TextStyle(
                                    color: greenButton,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 7.5, bottom: 7.5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Opacity(
                                  opacity: 0.15,
                                  child: Icon(
                                    Icons.person,
                                    color: greenButton,
                                    size: 40,
                                  ))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total Customers",
                                style: TextStyle(
                                    color: lightestText, fontSize: 13.5),
                              ),
                              Text(
                                dashboardLiveData['customers']['total'].toString(),
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dashboardLiveData['customers']['percentage'].toString()+"%",
                                style: TextStyle(
                                    color: greenButton,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.only(
                        top: 15, left: 7.5, right: 15, bottom: 7.5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Opacity(
                                  opacity: 0.15,
                                  child: Icon(
                                    Icons.people,
                                    color: greenButton,
                                    size: 40,
                                  ))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "People Online",
                                style: TextStyle(
                                    color: lightestText, fontSize: 13.5),
                              ),
                              Text(
                                dashboardLiveData['online']['total'].toString(),
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 33,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " ",
                                style: TextStyle(
                                    color: greenButton,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: iconColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Recent Orders",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
               /* FlatButton(
                  onPressed: () {},
                  child: Text("View all orders >"),
                )*/
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              children: createOrderList(),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.airport_shuttle,
                  color: iconColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Van Locations",
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 7.5,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("location").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages =
                      docs.map((doc) => vanCell(doc.data['location'])).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ));
  }

  Widget vanCell(dynamic vanData) {
    return GestureDetector(
      onTap: () 
      {
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanDetail(vanData["vanId"]),
            ));
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          child: Container(
            color: white,
            padding: EdgeInsets.all(10),
            child: SizedBox(
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Icon(Icons.airport_shuttle, color: lightestText)),
                  //SizedBox(width: 15,),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              vanData["driverName"],
                              style: TextStyle(
                                  color: darkText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            //SizedBox(width: 30,),
                            GestureDetector(
                              onTap: () {
                                showToast("map");
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 5, bottom: 5, left: 5),
                                child: Text("View Details >",
                                    style: TextStyle(
                                        color: darkGreen,
                                        decoration: TextDecoration.underline,
                                        fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                size: 13, color: lightestText),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              vanData["address"],
                              style: TextStyle(
                                  color: lightText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.directions_run,
                                    size: 13, color: lightestText),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  double.parse(vanData["speed"].toString())
                                          .toStringAsFixed(2) +
                                      " km/hr",
                                  style: TextStyle(
                                      color: lightText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Text(
                              vanData["isMoving"] ? "Moving" : "On Halt",
                              style: TextStyle(
                                  color: vanData["isMoving"]
                                      ? blueColor
                                      : Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  List<Widget> createOrderList() {
    List<Widget> ordersList = new List();
    List orderListFromServer = dashboardLiveData['recent']['orders'];
    for (int i = 0; i < orderListFromServer.length; i++) {
      ordersList.add(Container(
        color: white,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        padding: EdgeInsets.all(10),
        child: new Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Order id: #"+orderListFromServer[i]['order_id'],
                    style: TextStyle(
                        color: darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
                Text(orderListFromServer[i]['status'],
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                                  child: Text(orderListFromServer[i]['customer'],
                      style: TextStyle(
                          color: lightText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Text(orderListFromServer[i]['total'],
                    style: TextStyle(
                        color: greenButton,
                        fontSize: 15,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ));
    }
    return ordersList;
  }
}
