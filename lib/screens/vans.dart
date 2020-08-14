import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tampee_admin/screens/van_detail.dart';
import 'package:tampee_admin/utils/common.dart';

class VansList extends StatefulWidget {
  @override
  _VansListState createState() => _VansListState();
}

class _VansListState extends State<VansList> {

  final databaseReference = Firestore.instance;
  final Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Vans")),
      body: ListView(
        children: <Widget>[
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
        ],
      ),
      
    );
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



}