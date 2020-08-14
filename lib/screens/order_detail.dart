import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/utils/common.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  String orderId;
  OrderDetail(this.orderId);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  void initState() {
    getOrderDetailFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Order Detail")),
      body: isLoading ? Image.asset("assets/images/loading.gif") : Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: ListView(
              children: <Widget>[
                Container(
                    //color: white,
                    
                    margin: EdgeInsets.all(16),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "ORDER ID: #" +
                                    orderDetailObject['data']['order_id'],
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                orderDetailObject['data']['order_status'],
                                style: TextStyle(
                                  color: orderDetailObject['data']
                                              ['order_status'] ==
                                          "Pending"
                                      ? orange
                                      : orderDetailObject['data']
                                                  ['order_status'] ==
                                              "Complete"
                                          ? greenButton
                                          : orderDetailObject['data']
                                                      ['order_status'] ==
                                                  "Cancel"
                                              ? Colors.red
                                              : Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                orderDetailObject['data']['firstname'] +
                                    " " +
                                    orderDetailObject['data']['lastname'],
                                style: TextStyle(
                                    color: darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "",
                                style: TextStyle(
                                    color: blueColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text(
                            orderDetailObject['data']['email'],
                            style: TextStyle(
                                color: lightText,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 3),
                          Text(
                            orderDetailObject['data']['shipping_address']
                                .toString()
                                .replaceAll("<br />", ", "),
                            style: TextStyle(
                                color: lightestText,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 5),
                          Text(
                            orderDetailObject['data']['payment_method']
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                                color: blueColor,
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          Text(
                            "ITEMS",
                            style: TextStyle(
                                color: iconColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 7),
                          Column(
                            children: getItems(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "TOTALS",
                            style: TextStyle(
                                color: iconColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 7),
                          Column(
                            children: getTotals(),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getTotals() 
  {
    List<Widget> totalsList = new List();
    List totals = orderDetailObject['data']["totals"] as List;
    for (int i=0; i < totals.length; i++)
    {
        totalsList.add(new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(totals[i]['title'],
            style: TextStyle
            (
              color: lightText,
              fontSize: totals[i]['title'] == "Total" ? 18 : 14,
              fontWeight: totals[i]['title'] == "Total" ? FontWeight.bold : FontWeight.normal
            )),
            Text(totals[i]['text'],
            style: TextStyle
            (
              color: lightText,
              fontSize: totals[i]['title'] == "Total" ? 18 : 14,
              fontWeight: totals[i]['title'] == "Total" ? FontWeight.bold : FontWeight.normal
            )),
          ],
        ));
        totalsList.add(SizedBox(height: 5,));
    }
    

    return totalsList;
  }

  List<Widget> getItems() {
    List<Widget> itemsList = new List();
    List items = orderDetailObject['data']["products"] as List;
    for (int i = 0; i < items.length; i++) {
      itemsList.add(
        SizedBox(height: 5),
      );
      itemsList.add(Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Container(
                height: 80,
                width: 80,
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                    placeholder: 'assets/images/logo_grey.png',
                    image: "items[i]['images'][0]['image']"),
              ),
              SizedBox(width: 10,),*/
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      items[i]['name'],
                      style: TextStyle(
                          color: lightText,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            items[i]['quantity'] + "x",
                            style: TextStyle(
                                color: lightText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            items[i]['total'],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: lightText,
                                fontSize: 11.5,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ));
      itemsList.add(
        Divider(height: 30),
      );
    }

    return itemsList;
  }

  bool isLoading = true;
  dynamic orderDetailObject;
  Future<void> getOrderDetailFromServer() async {
    var preferences = await SharedPreferences.getInstance();
    print(getOrderDetailUrl);
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.post(getOrderDetailUrl, body: {
        "token": preferences.getString(api_token),
        "order_id": widget.orderId
      });

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if (responseJson['status']) {
          setState(() {
            orderDetailObject = responseJson;
            isLoading = false;
          });
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
}
