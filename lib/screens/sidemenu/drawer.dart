import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/screens/dashboard.dart';
import 'package:tampee_admin/screens/user/signin.dart';
import 'package:tampee_admin/utils/common.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  String nameString = "";
  String emailString = "";
  String phoneString = "";

  getDriveInfo() async
  {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      nameString = preferences.getString(firstname)+" "+ preferences.getString(lastname);
      emailString = preferences.getString(savedEmail);
      phoneString = preferences.getString(savedtelephone);
    });
    
  }

  @override
  void initState() {
    getDriveInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Container(
        color: darkText,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
                  child: ListView(
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.account_circle, size: 60, color: white,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(nameString,
                       style: TextStyle(
                         color: white,
                         fontSize: 18,
                         fontWeight: FontWeight.bold

                       ),),
                       SizedBox(height: 3,),
                       Text(emailString,
                       style: TextStyle(
                         color: lightGrey,
                         fontSize: 13
                       ),),
                       SizedBox(height: 3,),
                       Text(phoneString,
                       style: TextStyle(
                         color: lightGrey,
                         fontSize: 13
                       ),),
                    ],
                  ),
                ],
                
              ),
              SizedBox(height: 15,),
              Divider(color: lightText),
               ListTile(
                
                leading: Icon(Icons.list, size: 20, color: white),
                title: Text('Order History',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                     Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ))
                },
              ),
              Divider(color: lightText),
               ListTile(
                
                leading: Icon(Icons.exit_to_app, size: 20, color: white),
                title: Text('Logout',
                  style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                onTap: () => {
                  logoutDialog()
                   
                },
              ),
              Divider(color: lightText),
              
            ],
          ),
        ),
      ),
    );
  }


 void logoutDialog() {
   // Navigator.pop(context);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout!"),
          content: new Text("Are you sure, you want to logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes",
              style: TextStyle(
                color: darkText
              ),),
              onPressed: () {

                Navigator.of(context).pop();
                logout();
              },
            ),
            new FlatButton(
              child: new Text("Cancel",
                style: TextStyle(
                    color: primaryColor
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }


  void logout() async
  {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(username, '');
    preferences.setString(password, '');
    preferences.setInt(id, 0);
    preferences.setString(firstname, '');
    preferences.setString(savedEmail, '');
    preferences.setString(lastname, '');
    preferences.setBool(is_logged_in, false);
     Navigator.pushAndRemoveUntil(context, 
            MaterialPageRoute(
              builder: (context) => SignIn("finish"),
            ), (route) => false);
    //Navigator.of(context).pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
  }


}