import 'dart:convert';
import 'dart:js';

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
                String comments = controller.text;
                var now = DateTime.now();

                String applydata = Hesapla.dateTimeToString(now);

                Map<String, dynamic> data = {
                  'username': user.name,
                  'note': comments,
                  'applicant': user.uid,
                  'data': applydata
                };

                String jsencoded = jsonEncode(data);
                print(jsencoded);

                await _firestore
                    .collection('CreatedProjects201x')
                    .doc(proje.projectid)
                    .update({
                  'applicants': FieldValue.arrayUnion([jsencoded])
                });
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('email confirmation'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('We sent to a confirmation link'),
                              Text(
                                  'Please confirm your email to log in your accout'),
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
