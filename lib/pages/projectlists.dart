import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/questionModel.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/createProject.dart';
import 'package:greenaction/pages/searchproject.dart';
import 'package:greenaction/pages/viewproject.dart';

// ignore: must_be_immutable
class ProjeLists extends StatefulWidget {
  User user;

  ProjeLists({@required this.user});

  @override
  _ProjeListsState createState() => _ProjeListsState(user);
}

class _ProjeListsState extends State<ProjeLists> {
  // comment
  // commenting for github
  User user;
  List<ProjectModel> projelistesi = [];
  List<Question> questionlist = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> projeler = [];
  int documentLimit = 2;

  DocumentSnapshot lastDocument;

  QuerySnapshot querySnapshot;
  ScrollController _scrollController = ScrollController();

  _ProjeListsState(this.user);
  @override
  Widget build(BuildContext context) {
    print(user.name);
    return Scaffold(
      body: Column(
        children: [
          if (projelistesi.length > 0)
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: projelistesi.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 4),
                      child: Card(
                          color: Colors.white54,
                          elevation: 10,
                          shadowColor: Colors.black87,
                          child: ExpansionTile(
                            title: Text(projelistesi[index].headline),
                            leading: FutureBuilder(
                              future: ImageUploader().downloadProjectPic(
                                  projelistesi[index].projectid),
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
                            subtitle: Text(projelistesi[index].shortdetail),
                            trailing: Icon(Icons.search),
                            children: [
                              Column(
                                children: [
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Questions'),
                                  if (projelistesi[index].questionsOn == false)
                                    Text('Questions are not expected'),
                                  if (projelistesi[index].questions == '' &&
                                      projelistesi[index].questionsOn == true)
                                    Text('There is no question asked yet'),
                                  if (projelistesi[index].questionsOn == true)
                                    Text('View Project to ask a question'),
                                  if (projelistesi[index].questions != '' &&
                                      projelistesi[index].questionsOn == true)

//TODO put questions in an expansiontile
                                    Card(
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        itemCount: Question()
                                            .formJson(projelistesi[index])
                                            .length,
                                        itemBuilder: (context, no) {
                                          questionlist = ProjectModel()
                                              .getQuestionListfromProjectModel(
                                                  projelistesi[index]);
                                          return ListTile(
                                              title: Text(
                                                  questionlist[no].question),
                                              leading: Icon(Icons.person),
                                              subtitle: Text(
                                                  questionlist[no].answers));
                                        },
                                      ),
                                    ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Comments'),
                                  if (projelistesi[index].commentsOn == false)
                                    Text('Comments are not expected'),
                                  if (projelistesi[index].comments == null &&
                                      projelistesi[index].commentsOn == true)
                                    Text('There is no comment made yet'),
                                  if (projelistesi[index].commentsOn == true)
                                    Text('View Project to make a comment'),
                                  if (projelistesi[index].comments != null &&
                                      projelistesi[index].commentsOn == true)
//TODO put comments in an expansiontile
//TODO put user image to leading
//TODO read yaparken question fieldlere bak yoksa yaz
                                    Card(
                                      child: ListView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        itemCount:
                                            projelistesi[index].comments.length,
                                        itemBuilder: (context, no) {
                                          return ListTile(
                                              title: Text(jsonDecode(
                                                  projelistesi[index].comments[
                                                      no])['Username']),
                                              leading: Icon(Icons.person),
                                              subtitle: Text(jsonDecode(
                                                  projelistesi[index].comments[
                                                      no])['comment']));
                                        },
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.thumb_up),
                                          onPressed: null),
                                      Text('int'),
                                      IconButton(
                                          icon: Icon(Icons.thumb_down),
                                          onPressed: null),
                                      Text('int'),
                                      Expanded(child: SizedBox()),
                                      TextButton(
                                          onPressed: () async {
                                            questionlist = ProjectModel()
                                                .getQuestionListfromProjectModel(
                                                    projelistesi[index]);
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewProject(
                                                          questionlist:
                                                              questionlist,
                                                          user: user,
                                                          proje: projelistesi[
                                                              index],
                                                        )));
                                          },
                                          child: Text('View Project'))
                                    ],
                                  )
                                ],
                              )
                            ],
                          )),
                    );
                  }),
            ),
          IconButton(
              icon: Icon(Icons.alarm),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateProject(user: user)));
              }),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchProject(user: user)));
              }),
          TextButton(
              child: Text(
                'SHOW MORE',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () async {
                await projelistesiAl();
              }),
        ],
      ),
    );
  }

  projelistesiAl() async {
    print('projelistesiAl has been called');
    if (lastDocument == null) {
      print('projelistesiAl if condition');

      querySnapshot = await firestore
          .collection('CreatedProjects201x')
          .limit(documentLimit)
          .get();
    } else {
      print('projelistesiAl else condition');

      querySnapshot = await firestore
          .collection('CreatedProjects201x')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
    }

    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    print(lastDocument['headline']);

    projeler.addAll(querySnapshot.docs);

    projelistesi = ProjectModel().dataFromSnapShots(projeler);
    setState(() {
      user = user;
      return projelistesi;
    });
  }
}
