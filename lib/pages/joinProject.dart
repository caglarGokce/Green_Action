import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/hesapla.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/user.dart';

// ignore: must_be_immutable
class JoinProject extends StatelessWidget {
  final User user;
  final ProjectModel proje;
  JoinProject({@required this.proje, this.user});
  TextEditingController controller = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Do you have notes to the project organizer?'),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                fillColor: Colors.blue.shade100,
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () async {
                String notes = controller.text;
                var now = DateTime.now();

                String applydata = Hesapla.dateTimeToString(now);

                Map<String, dynamic> data = {
                  'username': user.name,
                  'note': notes,
                  'applicant': user.uid,
                  'data': applydata
                };
                Map<String, dynamic> projedata = {
                  'projectid': proje.projectid,
                  'headline': proje.headline,
                  'shortInfo': proje.shortdetail,
                };

                String jsencoded = jsonEncode(data);
                String projejs = jsonEncode(projedata);

                await _firestore
                    .collection('CreatedProjects201x')
                    .doc(proje.projectid)
                    .update({
                  'applicants': FieldValue.arrayUnion([jsencoded])
                });
                await _firestore
                    .collection('GoodGreenUsers')
                    .doc(user.uid)
                    .update({
                  'appliedProjects': FieldValue.arrayUnion([projejs])
                });
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: proje.iChoosePartcpnts == true
                            ? Text(
                                'You have succesfully applied to the project')
                            : Text('You have joined to the project'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              if (proje.iChoosePartcpnts == true)
                                if (proje.haveMessage == true)
                                  Text(proje.message),
                              if (proje.iChoosePartcpnts == true)
                                if (proje.haveMessage == false)
                                  Text(
                                      'You can join the project after the confirmation of project organizer'),
                              if (proje.iChoosePartcpnts == false)
                                Text(
                                    'You can contact the project organizer for questions'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                'Join',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
            )
          ],
        ),
      ),
    );
  }
}
