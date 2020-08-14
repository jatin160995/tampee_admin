import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampee_admin/screens/user/signin.dart';
import 'package:tampee_admin/utils/common.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String nameString = "";
  String emailString = "";

  getDriveInfo() async {
    var preferences = await SharedPreferences.getInstance();
    setState(() {
      nameString = preferences.getString(firstname) +
          " " +
          preferences.getString(lastname);
      emailString = preferences.getString(savedEmail);
    });
  }

  @override
  void initState() {
    getDriveInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Settings")),
        body: Container(
          margin: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Basic Information",
                        style: TextStyle(
                            color: greenButton,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Full Name",
                        style: TextStyle(
                            color: lightestText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        nameString,
                        style: TextStyle(
                            color: darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: lightestText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        emailString,
                        style: TextStyle(
                            color: darkText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                     
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Card(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Options",
                        style: TextStyle(
                            color: greenButton,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                     /* Row(
                        children: <Widget>[
                          Icon(
                            Icons.lock_open,
                            color: lightText,
                            size: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Change Password",
                            style: TextStyle(
                                color: darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),*/
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () 
                        {
logoutDialog();
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: lightText,
                              size: 22,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  color: darkText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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
