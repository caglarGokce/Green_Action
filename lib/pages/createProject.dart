import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:greenaction/hesapla.dart';
import 'package:greenaction/imageuploader.dart';
import 'package:greenaction/models/projectModel.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/previewproject.dart';
import 'package:greenaction/placeautocmplt.dart';

var photo;
File photoforFB;
bool isPhotoUploaded = false;
bool commentsOn = true;
bool questionsOn = true;

// ignore: must_be_immutable
class CreateProject extends StatelessWidget {
  User user;

  CreateProject({this.user});

  @override
  Widget build(BuildContext context) {
    TextEditingController headline = TextEditingController();
    TextEditingController sinfo = TextEditingController();
    TextEditingController location = TextEditingController();
    TextEditingController projectStart = TextEditingController();
    TextEditingController prize = TextEditingController();
    TextEditingController projectdetails = TextEditingController();
    TextEditingController minnumberofparticipants = TextEditingController();
    TextEditingController maxnumberofparticipants = TextEditingController();
    TextEditingController projectdeadline = TextEditingController();
    TextEditingController contactinfo = TextEditingController();
    TextInputFormatter integerformat =
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
    String projectid = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a project'),
      ),
      body: ListView(children: [
        ProjectPhoto(),
        Form(
            child: TextFormField(
          controller: headline,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'Project Headline',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
          child: TextFormField(
            controller: sinfo,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.note_add),
              hintText: 'short info about project',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 240,
          child: Form(
              child: TextFormField(
            maxLines: null,
            minLines: null,
            expands: true,
            controller: projectdetails,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.note_add),
              hintText: 'Project details',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          onTap: () async {
            String result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => LocationFinder()));
            location.text = result;
          },
          controller: location,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'location',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          keyboardType: TextInputType.number,
          controller: minnumberofparticipants,
          inputFormatters: [integerformat],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'minimum participants needed',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          keyboardType: TextInputType.number,
          controller: maxnumberofparticipants,
          inputFormatters: [integerformat],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'maximum participants needed',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          onTap: () async {
            var _projectDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime((DateTime.now().year + 10),
                  DateTime.now().month, DateTime.now().day),
            );
            projectStart.text = Hesapla.dateTimeToString(_projectDate);
          },
          controller: projectStart,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'project starting time',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          onTap: () async {
            var _projectDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime((DateTime.now().year + 10),
                  DateTime.now().month, DateTime.now().day),
            );
            projectdeadline.text = Hesapla.dateTimeToString(_projectDate);
          },
          controller: projectdeadline,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'project deadline',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          keyboardType: TextInputType.number,
          controller: prize,
          inputFormatters: [integerformat],
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'prize',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SizedBox(
          height: 20,
        ),
        Form(
            child: TextFormField(
          controller: contactinfo,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.note_add),
            hintText: 'contact info',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        )),
        SwitchComments(),
        SwitchQuestions(),
        TextButton(
            onPressed: () async {
              var now = DateTime.now();

              String date = Hesapla.dateTimeToString(now);
              projectid = await FireStore().createProjectId();

              ProjectModel proje = ProjectModel(
                  commentsOn: commentsOn,
                  questionsOn: questionsOn,
                  launchdate: date,
                  organizedBy: user.uid,
                  headline: headline.text,
                  shortdetail: sinfo.text,
                  projectdetails: projectdetails.text,
                  location: location.text,
                  minnumberofparticipants: minnumberofparticipants.text,
                  maxnumberofparticipants: maxnumberofparticipants.text,
                  starting: projectStart.text,
                  deadline: projectdeadline.text,
                  prize: prize.text,
                  contactinfo: contactinfo.text,
                  photo: photo,
                  projectid: projectid,
                  photoforFB: photoforFB,
                  isPhotoUploaded: isPhotoUploaded);
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreviewProject(
                            proje: proje,
                          )));
            },
            child: Text('preview'))
      ]),
    );
  }

  void annulatephoto() {
    photo = null;
  }
}

class SwitchQuestions extends StatefulWidget {
  @override
  _SwitchQuestionsState createState() => _SwitchQuestionsState();
}

class _SwitchQuestionsState extends State<SwitchQuestions> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (questionsOn == true) Text('Questions turned on'),
      if (questionsOn == false) Text('Questions turned off'),
      Switch(
        value: questionsOn,
        onChanged: (value) {
          setState(() {
            questionsOn = value;
          });
        },
        activeTrackColor: Colors.yellow,
        activeColor: Colors.orangeAccent,
      ),
    ]);
  }
}

class SwitchComments extends StatefulWidget {
  @override
  _SwitchCommentsState createState() => _SwitchCommentsState();
}

class _SwitchCommentsState extends State<SwitchComments> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (commentsOn == true) Text('Comments turned on'),
      if (commentsOn == false) Text('Comments turned off'),
      Switch(
        value: commentsOn,
        onChanged: (value) {
          setState(() {
            commentsOn = value;
          });
        },
        activeTrackColor: Colors.yellow,
        activeColor: Colors.orangeAccent,
      ),
    ]);
  }
}

class ProjectPhoto extends StatefulWidget {
  @override
  _ProjectPhotoState createState() => _ProjectPhotoState();
}

class _ProjectPhotoState extends State<ProjectPhoto> {
  @override
  Widget build(BuildContext context) {
    photo = photo ?? AssetImage('lib/assets/images/cat.png');
    return Column(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: photo,
              fit: BoxFit.fitHeight,
            ),
            shape: BoxShape.rectangle,
          ),
        ),
        IconButton(
            icon: Icon(Icons.photo),
            onPressed: () async {
              photoforFB = await ImageUploader().galeridenSec();
              if (photoforFB != null) {
                isPhotoUploaded = true;
              }
              setState(() {
                photo = FileImage(photoforFB);
              });
            }),
      ],
    );
  }
}
/*
Takvim ekle
Location Düzenle, class import et, virtual projects tickbox ekle,(consumer widget?)
google firebase console index ekle
View project before launch
Project photoes
How many people needed for project
character limit
*/