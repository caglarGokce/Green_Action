import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/authentication.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/localStore.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/placeautocmplt.dart';

enum profilepages { edit, profile }
String locationresult = '';

// ignore: must_be_immutable
class Profil extends StatefulWidget {
  User user;
  Profil({@required this.user});
  @override
  _ProfilState createState() => _ProfilState(user: user);
}

class _ProfilState extends State<Profil> {
  User user;
  _ProfilState({@required this.user});

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  profilepages _profilepages = profilepages.profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _profilepages == profilepages.profile
            ? profileWidget(context)
            : editProfile(),
      ),
    );
  }

  Scaffold profileWidget(BuildContext context) {
    callback() {
      setState(() {});
    }

    Future<bool> invitedBy = CustomAuthentication().inviterEmailUploader();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _profilepages = profilepages.edit;
                  });
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<Image>(
                    future: ImageUploader().directoryPath(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('error');
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: snapshot.data.image,
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
                IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      File image = await ImageUploader().galeridenSec();
                      await ImageUploader().uploadPic(image);
                      setState(() {});
                    }),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.motto,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.location,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            FutureBuilder<bool>(
                future: invitedBy,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('error');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == true) {
                      return Text('email');
                    }
                    return InvitedBy(callback: callback);
                  }
                  return Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
    );
  }

  editProfile() {
    TextEditingController nameController = TextEditingController();
    TextEditingController mottoController = TextEditingController();

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () {
                  setState(() {
                    _profilepages = profilepages.profile;
                  });
                }),
            Form(
              child: TextFormField(
                controller: nameController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note_add),
                  hintText: user.name,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Form(
              child: TextFormField(
                controller: mottoController,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note_add),
                  hintText: user.motto,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            SettingLocationState(),
            ElevatedButton(
                onPressed: () async {
                  //add try catcth

                  user.name = nameController.text == ''
                      ? user.name
                      : nameController.text;
                  user.motto = mottoController.text == ''
                      ? user.motto
                      : mottoController.text;
                  user.location = locationresult;
                  Map uploadingmap = user.toMap();

                  await _firestore
                      .collection('GoodGreenUsers')
                      .doc(user.uid)
                      .update(uploadingmap);
                  setState(() {
                    _profilepages = profilepages.profile;
                  });
                },
                child: Text('Update'))
          ],
        ),
      ),
    );
  }
}

class SettingLocationState extends StatefulWidget {
  @override
  _SettingStateState createState() => _SettingStateState();
}

class _SettingStateState extends State<SettingLocationState> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(child: Text(locationresult ?? 'Location')),
            SizedBox(
              width: 13,
            ),
            ElevatedButton(
                onPressed: () async {
                  setResultState(locationresult);
                  print(locationresult);
                },
                child: Text('search adress')),
          ],
        ),
      ],
    );
  }

  void setResultState(givenresult) async {
    locationresult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationFinder()));
    setState(() {
      givenresult = locationresult;
    });
  }
}

// ignore: must_be_immutable
class InvitedBy extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  String email = '';
  final Function callback;

  InvitedBy({this.callback});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: emailController,
            obscureText: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.note_add),
              hintText: 'email',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onChanged: (val) {
              email = emailController.text;
            },
          ),
        ),
        IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              await FireStore().uploadInvitingUsersMail(email);
              await callback();
            })
      ],
    );
  }
}
