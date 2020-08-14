import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/screens/order_detail.dart';
import 'package:tampee_admin/utils/common.dart';
import 'package:http/http.dart' as http;

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  DateTime startDate ;
  DateTime endDate = DateTime.now();
  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null )
      setState(() {
        startDate = picked;
      });
  }
  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:  startDate.add(Duration(days: 1)),
        firstDate: startDate.add(Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null )
      setState(() {
        endDate = picked;
      });
  }

  bool isNew = false;
  bool isProcessing = false;
  bool isShipped = false;
  bool isCompleted = false;
  bool isCancelled = false;

  double heightss = 0;
  double totalHeight = 400;

  @override
  void initState() {
    getOrdersFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            setState(() {
              heightss == totalHeight ? heightss = 0 : heightss = totalHeight;
            });
          },
        ),
      ], centerTitle: true, title: Text("Orders")),
      body: isLoading
          ? Image.asset("assets/images/loading.gif")
          : Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 50),
                      child: ListView(
                        children: createOrderList(),
                      ),
                    )),
                Align(alignment: Alignment.topCenter, child: filterLayout()),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      color: white,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Text(
                                  "Total Orders: " +
                                      ordersResponse['data']['total_orders']
                                          .toString(),
                                  style: TextStyle(
                                      color: lightestText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Text("Page No.",
                                  style: TextStyle(
                                      color: lightestText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Divider(
                                height: 1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (currentPage != 1) {
                                          currentPage--;
                                          getOrdersFromServer();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_left,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Text(
                                    currentPage.toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        int totalOrders = int.parse(
                                            ordersResponse['data']
                                                    ['total_orders']
                                                .toString());
                                        if (totalOrders >
                                            currentPage * pageLimit) {
                                          currentPage++;
                                          getOrdersFromServer();
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_right,
                                      size: 25,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            ),
    );
  }

  bool isLoading = true;
  dynamic orderListFromServer;
  dynamic currentPage = 1;
  dynamic ordersResponse;
  int pageLimit = 10;

  Future<void> getOrdersFromServer() async {
    var preferences = await SharedPreferences.getInstance();
    print(dashboardUrl);
    try {
      setState(() {
        isLoading = true;
      });
      Map mapToSend = {
        "token": preferences.getString(api_token),
        "filter_date_from" : startDate != null ? startDate.year.toString() + "-"+ startDate.month.toString() + "-"+startDate.day.toString() : "" ,
        "filter_date_to": endDate != null ? endDate.year.toString() + "-"+ endDate.month.toString() + "-"+endDate.day.toString() : "",
        "page": currentPage.toString(),
        "limit": pageLimit.toString(),
        "filter_order_status_id":
            selectedStatus != 0 ? selectedStatus.toString() : ""
      };
      print(mapToSend);
      final response = await http.post(getOrdersUrl, body: mapToSend);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        print(responseJson);
        if (responseJson['status']) {
          setState(() {
            ordersResponse = responseJson;
            orderListFromServer = responseJson['data']['orders'] as List;
            isLoading = false;
          });

          print(responseJson['data']['orders']);
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

  List<Widget> createOrderList() {
    List<Widget> ordersList = new List();
    for (int i = 0; i < orderListFromServer.length; i++) {
      ordersList.add(GestureDetector(
        onTap: () 
        {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => OrderDetail(orderListFromServer[i]['order_id'].toString()) ));
        },
        child: Container(
          color: white,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          padding: EdgeInsets.all(10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Order id: #" + orderListFromServer[i]['order_id'],
                      style: TextStyle(
                          color: darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                  Text(orderListFromServer[i]['order_status'],
                      style: TextStyle(
                          color: orderListFromServer[i]['order_status'] ==
                                  "Pending"
                              ? orange
                              : orderListFromServer[i]['order_status'] ==
                                      "Complete"
                                  ? Colors.green[600]
                                  : orderListFromServer[i]['order_status'] ==
                                          "Cancel"
                                      ? Colors.red
                                      : Colors.blue,
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
                  Text(orderListFromServer[i]['customer'],
                      style: TextStyle(
                          color: lightText,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  Text(orderListFromServer[i]['total'],
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5,),
              Text(orderListFromServer[i]['date_added'],
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ));
    }

    if (orderListFromServer.length == 0) {
      ordersList.add(new Center(
        child: Container(
            margin: EdgeInsets.only(top: 40),
            child: Text(
              "No Order Available",
              style: TextStyle(color: lightestText, fontSize: 20),
            )),
      ));
    }
    return ordersList;
  }

  int selectedStatus = 0; //
  Widget filterLayout() {
    return new AnimatedContainer(
        color: primaryColor,
        height: heightss,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(15),
            height: totalHeight,
            color: primaryColor,
            child: Visibility(
              visible: heightss == totalHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.filter_list,
                        color: lightestText,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Filters",
                        style: TextStyle(
                            color: lightestText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      _selectStartDate(context);
                    },
                    child: Text(
                      startDate == null ? "Date From: All" :"From: "+ startDate.day.toString()+"-"+startDate.month.toString()+"-"+startDate.year.toString(),
                      style: TextStyle(fontSize: 16, color: iconColor),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _selectEndDate(context);
                    },
                    child: Text(
                      endDate == null ? "Date To: All" :"To: "+ endDate.day.toString()+"-"+endDate.month.toString()+"-"+endDate.year.toString(),
                      style: TextStyle(fontSize: 16, color: iconColor),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Order Status",
                    style: TextStyle(fontSize: 13, color: lightestText),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedStatus == 1
                                      ? greenButton
                                      : iconColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                    color: selectedStatus == 1
                                        ? greenButton
                                        : iconColor,
                                    fontWeight: selectedStatus == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = 2;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedStatus == 2
                                      ? greenButton
                                      : iconColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "Processing",
                                style: TextStyle(
                                    color: selectedStatus == 2
                                        ? greenButton
                                        : iconColor,
                                    fontWeight: selectedStatus == 2
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = 3;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedStatus == 3
                                      ? greenButton
                                      : iconColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "Shipped",
                                style: TextStyle(
                                    color: selectedStatus == 3
                                        ? greenButton
                                        : iconColor,
                                    fontWeight: selectedStatus == 3
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = 5;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedStatus == 5
                                      ? greenButton
                                      : iconColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "Completed",
                                style: TextStyle(
                                    color: selectedStatus == 5
                                        ? greenButton
                                        : iconColor,
                                    fontWeight: selectedStatus == 5
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStatus = 7;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 7.5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: selectedStatus == 7
                                      ? greenButton
                                      : iconColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "Cancelled",
                                style: TextStyle(
                                    color: selectedStatus == 7
                                        ? greenButton
                                        : iconColor,
                                    fontWeight: selectedStatus == 7
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 7.5),
                          decoration: BoxDecoration(
                            border: Border.all(color: transparent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(color: iconColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = 0;
                            endDate = null;
                            startDate = null;
                          });
                        },
                        color: transparent,
                        child: Text(
                          "Clear Filters",
                          style: TextStyle(color: iconColor),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            currentPage = 1;
                            getOrdersFromServer();
                            heightss == totalHeight
                                ? heightss = 0
                                : heightss = totalHeight;
                          });
                        },
                        color: greenButton,
                        child: Text(
                          "APPLY",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
