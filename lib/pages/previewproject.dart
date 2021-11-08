import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/createProject.dart';
import 'package:greenaction/pages/home_page.dart';

class PreviewProject extends StatelessWidget {
  final User user;
  final ProjectModel proje;
  const PreviewProject({this.proje, this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: proje.photo,
                  fit: BoxFit.fitHeight,
                ),
                shape: BoxShape.rectangle,
              ),
            ),
            Text(
              proje.headline,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.shortdetail,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.projectdetails,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.location,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.starting,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.deadline,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.minnumberofparticipants,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.maxnumberofparticipants,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              proje.prize,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () async {
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;
                  if (proje.photoforFB != null) {
                    await ImageUploader()
                        .uploadProjectPic(proje.photoforFB, proje.projectid);
                  }

                  await _firestore
                      .collection('CreatedProjects201x')
                      .doc(proje.projectid)
                      .set(proje.toMap());
                  await _firestore
                      .collection('CreatedProjects201x')
                      .doc(proje.projectid)
                      .update(await FireStore().setProjectNo());

                  await _firestore
                      .collection('GoodGreenUsers')
                      .doc(user.uid)
                      .update({
                    'organizedProjects':
                        FieldValue.arrayUnion([proje.projectid])
                  });
                  CreateProject().annulatephoto();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
                },
                child: Text('launch'))
          ],
        ),
      ),
    );
  }
}
