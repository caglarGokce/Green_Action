import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/hesapla.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/questionModel.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/joinProject.dart';
import 'package:path_provider/path_provider.dart';

ScrollController _scrollController = ScrollController();

// ignore: must_be_immutable
class ViewProject extends StatelessWidget {
  Future<Directory> appDocDir = getApplicationDocumentsDirectory();
  ProjectModel proje;
  User user;
  List<Question> questionlist;
  ViewProject({this.proje, @required this.user, @required this.questionlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Row(
        children: [
          TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {},
              child: Text('Support this project',
                  style: TextStyle(
                    color: Colors.white,
                  ))),
          TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JoinProject(
                              proje: proje,
                              user: user,
                            )));
              },
              child: Text('Join this project',
                  style: TextStyle(
                    color: Colors.white,
                  )))
        ],
      ),
      appBar: AppBar(
        title: Text('${proje.headline}'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Profilinfo(appDocDir: appDocDir, proje: proje),
            Questions(
              proje: proje,
              user: user,
              questionlist: questionlist,
            ),
            Divider(),
            Comments(
              proje: proje,
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Profilinfo extends StatelessWidget {
  Profilinfo({
    @required this.appDocDir,
    @required this.proje,
  });

  final Future<Directory> appDocDir;
  ProjectModel proje;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      children: [
        FutureBuilder(
            future: appDocDir,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('error');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: proje.isPhotoUploaded
                          ? FileImage(File(
                              '${snapshot.data.path}/${proje.projectid}.jpg'))
                          : AssetImage('lib/assets/images/cat.png'),
                      fit: BoxFit.fitHeight,
                    ),
                    shape: BoxShape.rectangle,
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
        Text(
          proje.headline,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          proje.shortdetail,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          proje.prize,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        ),
        Text(
          proje.location,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        ),
        Text(
          proje.starting,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class Questions extends StatefulWidget {
  ProjectModel proje;
  User user;
  List<Question> questionlist;

  Questions({this.proje, this.user, this.questionlist});

  @override
  _QuestionsState createState() => _QuestionsState(proje, user, questionlist);
}

class _QuestionsState extends State<Questions> {
  ProjectModel proje;
  User user;
  List<Question> questionlist;
  var date = DateTime.now();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _QuestionsState(this.proje, this.user, this.questionlist);
  TextEditingController controller = TextEditingController();
  String answerstring = '';
  @override
  Widget build(BuildContext context) {
    int forlistview = questionlist.length;

    return ExpansionTile(
      title: Text('Questions'),
      trailing: Icon(Icons.arrow_circle_down),
      children: [
        Text('Questions'),
        if (proje.questionsOn == false) Text('Questions are not expected'),
        if (proje.questionsOn == true)
          if (questionlist == null || questionlist.length == 0)
            Text('There is no question asked yet'),
        if (questionlist.length > 0)
          Card(
            child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: forlistview + 1,
              itemBuilder: (context, no) {
                if (no == forlistview) {
                  return SizedBox(
                    height: 1,
                  );
                }
                return ListTile(
                  title: Text(questionlist[no].question),
                  subtitle: Text(questionlist[no].answers),
                  trailing: questionlist[no].whoisAsking == user.uid
                      ? TextButton(
                          onPressed: () async {
                            questionlist.removeAt(no);
                            String jsencoded = jsonEncode(questionlist);
                            Map<String, String> map = {'questions': jsencoded};
                            await _firestore
                                .collection('CreatedProjects201x')
                                .doc(proje.projectid)
                                .update(map);
                            setState(() {});
                            DocumentSnapshot ds = await _firestore
                                .collection('CreatedProjects201x')
                                .doc(proje.projectid)
                                .get();
                            setState(() {
                              proje = ProjectModel().datafromdocument(ds);
                            });
                          },
                          child: Text('delete question'))
                      : TextButton(
                          onPressed: () {
                            print(questionlist[no].whoisAsking);
                            print(user.uid);
                          },
                          child: Text('report question')),
                );
              },
              separatorBuilder: (context, no) => proje.organizedBy == user.uid
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                onChanged: (val) {
                                  answerstring = val;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5),
                                    fillColor: Colors.blue.shade100,
                                    border: OutlineInputBorder(),
                                    labelText: 'reply the queston above'),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                String date =
                                    Hesapla.dateTimeToString(this.date);
                                if (questionlist[no].isreplied == false) {
                                  questionlist[no].answers =
                                      'replied on $date\n$answerstring';
                                } else {
                                  questionlist[no].answers =
                                      'the answer updated on $date\n$answerstring';
                                }
                                questionlist[no].isreplied = true;
                                String jsencoded = jsonEncode(questionlist);
                                Map<String, String> map = {
                                  'questions': jsencoded
                                };
                                await _firestore
                                    .collection('CreatedProjects201x')
                                    .doc(proje.projectid)
                                    .update(map);
                                setState(() {});
                              },
                              child: questionlist[no].isreplied == false
                                  ? Text('Reply')
                                  : Text('Edit Answer'),
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  : Divider(
                      color: Colors.blue,
                    ),
            ),
          ),
        if (proje.questionsOn == true)
          Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(40),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                  labelText: 'label',
                  hintText: 'hint',
                  helperText: 'help',
                  counterText: 'counter',
                  icon: Icon(Icons.star),
                  prefixIcon: Icon(Icons.favorite),
                  suffixIcon: Icon(Icons.park),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  DocumentSnapshot ds = await _firestore
                      .collection('CreatedProjects201x')
                      .doc(proje.projectid)
                      .get();
                  questionlist =
                      ProjectModel().getQuestionListfromDocSnapshot(ds);

                  var now = DateTime.now();

                  String questiondate = Hesapla.dateTimeToString(now);

                  String questiontext = controller.text;

                  Question question = Question(
                      answers: 'There is no answer yet',
                      date: questiondate,
                      question: questiontext,
                      whoisAsking: user.uid);

                  questionlist.add(question);
                  String jsencoded = jsonEncode(questionlist);
                  Map<String, String> map = {'questions': jsencoded};
                  await _firestore
                      .collection('CreatedProjects201x')
                      .doc(proje.projectid)
                      .update(map);
                  setState(() {});
                },
                child: Text('SEND', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
      ],
    );
  }
}

//TODO add validator, ispressed, circular progress indicator, to forms.

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  ProjectModel proje;
  User user;
  Comments({this.proje, this.user});
  @override
  _CommentsState createState() => _CommentsState(proje, user);
}

class _CommentsState extends State<Comments> {
  ProjectModel proje;
  User user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _CommentsState(this.proje, this.user);
  TextEditingController commentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Comments'),
      trailing: Icon(Icons.arrow_circle_down),
      children: [
        if (proje.commentsOn == false) Text('Comments are not expected'),
        if (proje.comments.length == 0 && proje.commentsOn == true)
          Text('There is no comment made yet'),
        if (proje.comments.length != 0 && proje.commentsOn == true)
          Card(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: proje.comments.length,
              itemBuilder: (context, no) {
                return ListTile(
                  title: Text(jsonDecode(proje.comments[no])['Username'] +
                      '     ' +
                      jsonDecode(proje.comments[no])['data']),
                  leading: Icon(Icons.person),
                  subtitle: Text(jsonDecode(proje.comments[no])['comment']),
                  trailing: jsonDecode(proje.comments[no])['madeBy'] == user.uid
                      ? TextButton(
                          onPressed: () async {
                            print(jsonDecode(proje.comments[no])['madeBy']);
                            print('userUID: ${user.uid}');

                            await _firestore
                                .collection('CreatedProjects201x')
                                .doc(proje.projectid)
                                .update({
                              'comments':
                                  FieldValue.arrayRemove([proje.comments[no]])
                            });
                            DocumentSnapshot ds = await _firestore
                                .collection('CreatedProjects201x')
                                .doc(proje.projectid)
                                .get();
                            setState(() {
                              proje = ProjectModel().datafromdocument(ds);
                            });
                          },
                          child: Text('delete comment'))
                      : TextButton(
                          onPressed: () {
                            //TODO report page and report collection
                          },
                          child: Text('report comment')),
                );
              },
            ),
          ),
        if (proje.commentsOn == true)
          Column(
            children: [
              TextField(
                controller: commentcontroller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(40),
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                  labelText: 'label',
                  hintText: 'hint',
                  helperText: 'help',
                  counterText: 'counter',
                  icon: Icon(Icons.star),
                  prefixIcon: Icon(Icons.favorite),
                  suffixIcon: Icon(Icons.park),
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () async {
                    String comments = commentcontroller.text;
                    var now = DateTime.now();

                    String commentdata = Hesapla.dateTimeToString(now);

                    Map<String, dynamic> data = {
                      'Username': user.name,
                      'comment': comments,
                      'madeBy': user.uid,
                      'data': commentdata
                    };

                    String jsencoded = jsonEncode(data);
                    print(jsencoded);

                    await _firestore
                        .collection('CreatedProjects201x')
                        .doc(proje.projectid)
                        .update({
                      'comments': FieldValue.arrayUnion([jsencoded])
                    });
                    DocumentSnapshot ds = await _firestore
                        .collection('CreatedProjects201x')
                        .doc(proje.projectid)
                        .get();
                    setState(() {
                      proje = ProjectModel().datafromdocument(ds);
                    });
                  },
                  child: Text(
                    'SEND',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
}




//report abuse
//report project
//report user button
//report comments button
