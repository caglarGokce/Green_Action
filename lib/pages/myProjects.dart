import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/questionModel.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/viewproject.dart';

// ignore: must_be_immutable
class MyProjects extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> questionlist = [];
  User user;
  MyProjects({this.user});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //tab count
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: TabBar(
            unselectedLabelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text('Applied Projects'),
              ),
              Tab(
                child: Text('Organized Projects'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: user.appliedProjects.length,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: ListTile(
                              title: jsonDecode(
                                  user.appliedProjects[item])['headline'],
                              subtitle: jsonDecode(
                                  user.appliedProjects[item])['shortInfo'],
                              leading: FutureBuilder(
                                future: ImageUploader().downloadProjectPic(
                                    jsonDecode(user.appliedProjects[item])[
                                        'projectid']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'lib/assets/images/cat.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'lib/assets/images/cat.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    if (snapshot.data == null) {
                                      return Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'lib/assets/images/cat.png'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(snapshot.data),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      );
                                    }
                                  }
                                  return Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'lib/assets/images/cat.png'),
                                        fit: BoxFit.fitHeight,
                                      ),
                                      shape: BoxShape.rectangle,
                                    ),
                                  );
                                },
                              ),
                              trailing: TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot ds = await _firestore
                                        .collection('CreatedProjects201x')
                                        .doc(jsonDecode(
                                                user.appliedProjects[item])[
                                            'projectid'])
                                        .get();
                                    ProjectModel proje =
                                        ProjectModel().datafromdocument(ds);

                                    questionlist = ProjectModel()
                                        .getQuestionListfromProjectModel(proje);
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewProject(
                                                  questionlist: questionlist,
                                                  user: user,
                                                  proje: proje,
                                                )));
                                  },
                                  child: Text('View Project')),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            //See and confirm applicants
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: user.organizedProjects.length,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: ListTile(
                              title: jsonDecode(
                                  user.organizedProjects[item])['headline'],
                              subtitle: jsonDecode(
                                  user.organizedProjects[item])['shortInfo'],
                              leading: FutureBuilder(
                                future: ImageUploader().downloadProjectPic(
                                    jsonDecode(user.organizedProjects[item])[
                                        'projectid']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'lib/assets/images/cat.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Container(
                                      height: 50.0,
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'lib/assets/images/cat.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    if (snapshot.data == null) {
                                      return Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'lib/assets/images/cat.png'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(snapshot.data),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      );
                                    }
                                  }
                                  return Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'lib/assets/images/cat.png'),
                                        fit: BoxFit.fitHeight,
                                      ),
                                      shape: BoxShape.rectangle,
                                    ),
                                  );
                                },
                              ),
                              trailing: TextButton(
                                  onPressed: () async {
                                    DocumentSnapshot ds = await _firestore
                                        .collection('CreatedProjects201x')
                                        .doc(jsonDecode(
                                                user.organizedProjects[item])[
                                            'projectid'])
                                        .get();
                                    ProjectModel proje =
                                        ProjectModel().datafromdocument(ds);

                                    questionlist = ProjectModel()
                                        .getQuestionListfromProjectModel(proje);
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewProject(
                                                  questionlist: questionlist,
                                                  user: user,
                                                  proje: proje,
                                                )));
                                  },
                                  child: Text('View Project')),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
