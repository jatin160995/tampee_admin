import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tampee_admin/utils/common.dart';

class VanDetail extends StatefulWidget {
  String vanId;
  VanDetail(this.vanId);

  @override
  _VanDetailState createState() => _VanDetailState();
}

class _VanDetailState extends State<VanDetail> {
  final databaseReference = Firestore.instance;
  final Firestore _firestore = Firestore.instance;

  GoogleMapController _controller;
  Set<Marker> markers = new Set();

  double lat = 0.0;
  double lng = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // _controller.setMapStyle(_mapStyle);

    // _controller.add
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Van Details")),
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

                List<Widget> messages = docs
                    .map((doc) => widget.vanId == doc.data['location']['vanId']
                        ? vanCell(doc.data['location'])
                        : Container())
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...messages,
                  ],
                );
              },
            ),
          ),
         
          Container(
            margin: EdgeInsets.all(15),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 200,
                child: GoogleMap(
                  markers: markers,
                  onMapCreated: _onMapCreated,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
                  onCameraMove: ((pinPosition) {
                    // print(pinPosition.target.latitude);
                    // print(pinPosition.target.longitude);
                  }),
                  //myLocationEnabled: true,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Text(
                    "Bookings",
                    style: TextStyle(
                        color: iconColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
          ),
           Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("user_requests").orderBy("created_at")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> messages = docs
                      .map((doc) => !doc.data['requests']['isFinished']
                          ? bookingCell(doc.data, doc.documentID)
                          : Container())
                      .toList();

                  return Column(
                    //controller: scrollController,
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

  int cameraCount = 0;

  addMarker(dynamic vanData) async {
    BitmapDescriptor bitmapDescriptor1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1), 'assets/images/van1.png');
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("Van1"),
          position: LatLng(vanData['lat'], vanData['lng']),
          rotation: vanData["heading"],
          infoWindow: InfoWindow(
            title: "Van Location",
          ),
          draggable: true,
          icon: bitmapDescriptor1));
    });
    cameraCount++;
    if (cameraCount % 30 == 0) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(vanData['lat'], vanData['lng']), zoom: 16.0),
      ));
      cameraCount = 0;
    }
  }



  Widget bookingCell(dynamic bookingDataRequest, dynamic documentId) {
    dynamic bookingData = bookingDataRequest['requests'];
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text("🙋🏻‍♂️", style: TextStyle(fontSize: 18))),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bookingData['customer_name'],
                        style: TextStyle(
                            color: darkText, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        bookingData['address'],
                        style: TextStyle(color: lightestText),
                      ),
                      Text(
                        !bookingData['isAccepted'] ? "Pending" : "Processing",
                        style: TextStyle(
                            color: !bookingData['isAccepted']
                                ? Colors.orange
                                : greenButton),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                     
                    ],
                  ),
                ],
              ),
              
                  
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Divider(
            height: 8,
          ),
        )
      ],
    );
  }

  Widget vanCell(dynamic vanData) {
    addMarker(vanData);
    return GestureDetector(
      onTap: () {
       /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VanDetail(vanData["vanId"]),
            ));*/
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
                            /* GestureDetector(
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
                            )*/
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
