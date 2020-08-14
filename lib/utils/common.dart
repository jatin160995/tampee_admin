import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


const primaryColor = Color(0xFF222222);
//const primaryColor = Color(0xFF3aaa35);
const white = Color(0xffffffff);
const background = Color(0xFFf8f8f8);
//const accent = Color(0xFFED3134);
const darkText = Color(0xFF222222);
const lightText = Color(0xFF454545);
const lightestText = Color(0xFF656565);
const transparent = Color(0x005391cf);
const transparentBlack = Color(0xa0000000);
const transparentBackground = Color(0x20000000);
const lightGrey = Color(0xa0d8d8d8);
const iconColor = Color(0xffc0c0c0);
const transparentREd = Color(0x70df0000);
const backgroundGrey = Color(0xFF90a4ae);
const statusBarColor = Color(0xffd8d8d8);
const greenButton = Color(0xff62B498);
const darkGreen = Color(0xff1C9860);
const orange = Color(0xfffa7e37);
const blueColor = Colors.blue;


const apiKey = "l0Mk3ReiBVXuiOQ7LVk0dWcND0xOHe14uI9vaPFNnJvTcuc8kQR8PLEuuttDYYyALnPvEb13yvET82JFNtbmcjj7NM7fJ1CPx9vQZAHPXTPi2KnY9UXYMWpU1iKElZPAu7MJaBDeCTuG2Vv3rc4iSCQICXVScXNLIIX1JXn74WTAagq6o3nHqMAS3mPiPIuGCAsPuz6hWl8Pz1dA3sBCX52MhtIBmJ92PFjZCKUkoOHH5HyGF1dfDdLMZyLUcr8N";
const url_string = "https://aashya.com/g/tampee/";
const contentType = 'application/json';
const website_username = "tampee";

const getTokenUrl = url_string + "index.php?route=api/login";
const driverOrders = url_string + "index.php?route=api/van/orders";
const login = url_string + "admin/index.php?route=api/login";
const dashboardUrl = url_string + "admin/index.php?route=api/dashboard";
const getOrdersUrl = url_string + "admin/index.php?route=api/order";
const getOrderDetailUrl = url_string + "admin/index.php?route=api/order/get";



String api_token = 'api_token';
String is_logged_in = 'is_logged_in';
String username = 'username';
String password = 'password';
String savedEmail = 'savedEmail';
String firstname = 'firstname';
String lastname = 'lastname';
String savedtelephone = "savedtelephone";
String id = 'id';


String inr = "Rs. ";


void showToast(String message)
{
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0
  );
}