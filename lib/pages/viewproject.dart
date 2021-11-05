import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/hesapla.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/questionModel.dart';
import 'package:greenaction/models/user.dart';
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

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _QuestionsState(this.proje, this.user, this.questionlist);
  TextEditingController controller = TextEditingController();
  String answerstring = '';
  @override
  Widget build(BuildContext context) {
    int forlistview = questionlist.length;
    int forseperator = questionlist.length + 1;

    return Column(
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
                                questionlist[no].answers = answerstring;
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
                              child: questionlist[no].answers ==
                                      'There is no answer yet'
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
                  int countanswers;

                  Question question = Question(
                      answers: 'There is no answer yet',
                      answerCounter: countanswers,
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

//TODO reply buttons are empty
//TODO add validator to forms
//TODO add isPressed to the comment buttons
//TODO add circular progress indicator to the buttons
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
    return Column(
      children: [
        Text('Comments'),
        if (proje.commentsOn == false) Text('Comments are not expected'),
        if (proje.commentsOn == true)
          if (proje.comments == null || proje.comments.length == 0)
            Text('There is no comment made yet'),
        if (proje.comments != null)
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
                    subtitle: Text(jsonDecode(proje.comments[no])['comment']));
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
          )
      ],
    );
  }
}

//Answer question widget
// get the related question string update with an answer
//update answer button
//delete question button
//report abuse
//report project
//report user button
//report comments button
