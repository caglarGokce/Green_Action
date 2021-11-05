import 'dart:io';

import 'package:flutter/material.dart';
import 'package:greenaction/authentication.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/localStore.dart';
import 'package:greenaction/placeautocmplt.dart';

enum profilepages { edit, profile }

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String location = 'location';
  String name = 'name';
  String myEmail = CustomAuthentication().getEmail();
  String motto = 'motto';
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
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () async {
                      String emaiul = CustomAuthentication().getEmail();
                      print(emaiul);
                    }),
              ],
            ),
            FutureBuilder<Map>(
                future: LocalStore().getFilePath(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('Snaphot:${snapshot.data}');
                    print(snapshot.data);
                    print(snapshot.data);
                    return Text('error');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data['name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data['motto'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data['location'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          myEmail,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
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
                  hintText: 'Name',
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
                  hintText: 'Fuckin motto',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Row(
              children: [
                Text(LocationFinder().getLocation()),
                ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationFinder()));
                    },
                    child: Text('search adress')),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  //add try catcth
                  FireStore().uploadDatatoFB(LocationFinder().getLocation(),
                      nameController.text, mottoController.text);
                },
                child: Text('Update'))
          ],
        ),
      ),
    );
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
