import 'package:flutter/material.dart';
import 'package:greenaction/authentication.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:greenaction/pages/RegisterPage.dart';
import 'package:greenaction/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<bool> _initializeSharedPref(uid) async {
    final _preferences = await SharedPreferences.getInstance();
    final initialBool = _preferences.getBool('fld$uid');
    if (initialBool == null) {
      print('fields initialized to false');

      return false;
    }
    print('initialized: fields initialized');

    return initialBool;
  }

  Future<bool> _initializeInviterEmail(uid) async {
    final _preferences = await SharedPreferences.getInstance();
    final initialBool = _preferences.getBool('inv$uid');
    if (initialBool == null) {
      print('inviter initialized to false');
      return false;
    }
    print('initialized: inviter initialized');

    return initialBool;
  }

  Future<bool> _initializeFirtTimeSharedPref(uid) async {
    final _preferences = await SharedPreferences.getInstance();
    final initialBool = _preferences.getBool('first$uid');
    if (initialBool == null) {
      print('firstTime  initialized to false');

      return false;
    }
    print('initialized: firsttime initialized');

    return initialBool;
  }

  Future<void> sharedPref(String uid) async {
    final _preferences = await SharedPreferences.getInstance();

    bool lastvalue = await _initializeSharedPref(uid);
    await _preferences.setBool('fld$uid', lastvalue);
    if (lastvalue == false) {
      FireStore().uploadFieldstoFB(CustomAuthentication().getEmail(), uid);
      print('fields initialized condition');
    }
    print('fields initialized');
  }

  Future<void> inviterPref(String uid) async {
    final _preferences = await SharedPreferences.getInstance();

    bool lastvalue = await _initializeInviterEmail(uid);
    await _preferences.setBool('inv$uid', lastvalue);
    print('inviter initialized');
  }

  Future<void> firstTimePref(String uid) async {
    final _preferences = await SharedPreferences.getInstance();

    bool lastvalue = await _initializeFirtTimeSharedPref(uid);
    await _preferences.setBool('first$uid', lastvalue);
    print('firsttime initialized');
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<CustomAuthentication>(context, listen: false);

    return StreamBuilder(
      stream: _auth.authStatus(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null &&
              CustomAuthentication().emailVerified() == true) {
            sharedPref(_auth.getUID());
            firstTimePref(_auth.getUID());
            inviterPref(_auth.getUID());

            return HomePage();
          }
          return RegisterPage();
        } else {
          return SizedBox(
            height: 300,
            width: 300,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
