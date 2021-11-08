import 'package:flutter/material.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/myProjects.dart';
import 'package:greenaction/pages/profile.dart';

// ignore: must_be_immutable
class SideDrawer extends StatelessWidget {
  User user;
  SideDrawer({this.user});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Side menu  FlutterCorner',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profil()));
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Wallet'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('My Projects'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyProjects(user: user)))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
