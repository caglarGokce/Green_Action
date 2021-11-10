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
bool iChoosePartcpnts = false;
bool chosePartRandom = true;
bool firstPartcptes = true;
bool haveMessage = false;
String message = '';
bool projectstartcheckbox = true;
bool projectstartcheckbox2 = true;
bool projectstartcheckbox3 = false;
bool projectstartcheckbox4 = false;
bool projectstartcheckbox5 = false;
int numberofparticipants = 0;
int amountofdonation = 0;
bool projectstartbetweencheckbox = true;

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
    TextEditingController projectStartbetween1 = TextEditingController();
    TextEditingController projectStartbetween2 = TextEditingController();
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Divider(
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
        ProjStartdate(
            projectStart: projectStart,
            projectStartbetween1: projectStartbetween1,
            projectStartbetween2: projectStartbetween2),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Divider(
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
        ProjFinishDate(projectdeadline: projectdeadline),
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
        Participants(),
        HaveMessage(),
        TextButton(
            onPressed: () async {
              var now = DateTime.now();

              String date = Hesapla.dateTimeToString(now);
              projectid = await FireStore().createProjectId();

              ProjectModel proje = ProjectModel(
                  haveMessage: haveMessage,
                  participants: [],
                  applicants: [],
                  message: message,
                  comments: [],
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
                            user: user,
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
  //TODO location can be virtual
  //TODO participants may not be needed
  //TODO projects date may start on when participants gathered or
  //donation gathered
  //or indefinite time
  // or there is no start time it is a constant project
  // can participants join on going project

  //projenin belli bir baslangic tarihi var mi(proje bu tarihte baslamak zorunda)
  //belli tarihler arasinda baslayacak(mesela mart ayinda baslayacak. martin 31 inde otomatik baslar.
  // mart icinde birgun organizator projeyi baslatabilir)
  // baslangic icin esneklik var mi(sinirsiz veya belli bir sure)

  //projenin belli bir bitis tarihi var mi(proje bu tarihten oteye gecemeyecek sonlanacak)
  //belli tarhler arasinda sonlanacak(mesela aralik ayi icinde aralik 31 de proje kendisi sonlanir.
  // aralik ayi icinde organizator herhangi bir gun sonlandirabilir)
  //projenin bitis tarihi kesin mi(bir esneklik olabilir mi)(sinirsiz veya belli bir sure)

  //projenin belli bir termin suresi var mi(proje basladiktan sonra bu sure icinde bitmek zorunda)
  //(belli bir sure uzatilabilir)

}

class ProjFinishDate extends StatelessWidget {
  const ProjFinishDate({
    Key key,
    @required this.projectdeadline,
  }) : super(key: key);

  final TextEditingController projectdeadline;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: TextFormField(
      onTap: () async {
        var _projectDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime((DateTime.now().year + 10), DateTime.now().month,
              DateTime.now().day),
        );
        projectdeadline.text = Hesapla.dateTimeToString(_projectDate);
      },
      controller: projectdeadline,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.note_add),
        hintText: 'project deadline',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ));
  }
}

class ProjStartdate extends StatefulWidget {
  const ProjStartdate(
      {@required this.projectStart,
      @required this.projectStartbetween1,
      @required this.projectStartbetween2});

  final TextEditingController projectStart;
  final TextEditingController projectStartbetween1;
  final TextEditingController projectStartbetween2;

  @override
  _ProjStartdateState createState() => _ProjStartdateState();
}

class _ProjStartdateState extends State<ProjStartdate> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Do you want project to start  as soon as you launch it?'),
      Row(children: [
        if (projectstartcheckbox3 == true)
          Text('Yes, start the project as soon as it is listed'),
        if (projectstartcheckbox3 == false) Text('No, i want to wait'),
        Switch(
          value: projectstartcheckbox3,
          onChanged: (value) {
            setState(() {
              projectstartcheckbox3 = value;
            });
          },
          activeTrackColor: Colors.yellow,
          activeColor: Colors.orangeAccent,
        ),
      ]),
      if (projectstartcheckbox3 == false)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Does your project have a starting date?'),
            Row(children: [
              if (projectstartcheckbox == true) Text('Yes it has'),
              if (projectstartcheckbox == false) Text('No it hasnt'),
              Switch(
                value: projectstartcheckbox,
                onChanged: (value) {
                  setState(() {
                    projectstartcheckbox = value;
                  });
                },
                activeTrackColor: Colors.yellow,
                activeColor: Colors.orangeAccent,
              ),
            ]),
            if (projectstartcheckbox == true)
              Column(
                children: [
                  Text(
                      'Does your project have a definite starting date or may start in between 2 dates?'),
                  Row(children: [
                    if (projectstartcheckbox2 == true)
                      Text('Project starts on a definite time'),
                    if (projectstartcheckbox2 == false)
                      Text('Project may start between 2 dates'),
                    Switch(
                      value: projectstartcheckbox2,
                      onChanged: (value) {
                        setState(() {
                          projectstartcheckbox2 = value;
                        });
                      },
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                    ),
                  ]),
                  if (projectstartcheckbox2 == true)
                    Column(
                      children: [
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
                            widget.projectStart.text =
                                Hesapla.dateTimeToString(_projectDate);
                          },
                          controller: widget.projectStart,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            hintText: 'project starting time',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )),
                      ],
                    ),
                  if (projectstartcheckbox2 == false)
                    Column(
                      children: [
                        Text('Project may start between '),
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
                            widget.projectStartbetween1.text =
                                Hesapla.dateTimeToString(_projectDate);
                          },
                          controller: widget.projectStartbetween1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            hintText: 'project may start...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )),
                        Text('and'),
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
                            widget.projectStartbetween2.text =
                                Hesapla.dateTimeToString(_projectDate);
                          },
                          controller: widget.projectStartbetween2,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            hintText: 'project may start...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )),
                      ],
                    ),
                ],
              ),
            if (projectstartcheckbox == false)
              Column(
                children: [
                  Text(
                      'Do you need minimum number of participants to start this project?'),
                  Row(children: [
                    if (projectstartcheckbox4 == true) Text('Yes i do'),
                    if (projectstartcheckbox4 == false) Text('No i dont'),
                    Switch(
                      value: projectstartcheckbox4,
                      onChanged: (value) {
                        setState(() {
                          projectstartcheckbox4 = value;
                        });
                      },
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                    ),
                  ]),
                  if (projectstartcheckbox4 == true) ConditionParticipants(),
                  Text(
                      'Do you need minimum amount of donation to start this project?'),
                  Row(
                    children: [
                      if (projectstartcheckbox5 == true) Text('Yes i do'),
                      if (projectstartcheckbox5 == false) Text('No i dont'),
                      Switch(
                        value: projectstartcheckbox5,
                        onChanged: (value) {
                          setState(() {
                            projectstartcheckbox5 = value;
                          });
                        },
                        activeTrackColor: Colors.yellow,
                        activeColor: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  if (projectstartcheckbox5 == true) ConditionDonation(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Do you have another condition to start project? '),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        fillColor: Colors.blue.shade100,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        )
    ]);
  }
}

class ConditionDonation extends StatefulWidget {
  @override
  _ConditionDonationState createState() => _ConditionDonationState();
}

class _ConditionDonationState extends State<ConditionDonation> {
  TextEditingController controllerdonation = TextEditingController();
  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Project will start when  amount of donations will reach $amountofdonation',
        ),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controllerdonation,
            onChanged: (_) {
              setState(() {
                if (controllerdonation.text.isEmpty) {
                  amountofdonation = 0;
                } else {
                  amountofdonation = int.parse(controllerdonation.text);
                }
              });
            },
            inputFormatters: [integerformat],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              fillColor: Colors.blue.shade100,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class ConditionParticipants extends StatefulWidget {
  @override
  _ConditionParticipantsState createState() => _ConditionParticipantsState();
}

class _ConditionParticipantsState extends State<ConditionParticipants> {
  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  TextEditingController controllerpartcpnt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Project will start when  number of participants will reach $numberofparticipants',
        ),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: controllerpartcpnt,
            onChanged: (_) {
              setState(() {
                if (controllerpartcpnt.text.isEmpty) {
                  numberofparticipants = 0;
                } else {
                  numberofparticipants = int.parse(controllerpartcpnt.text);
                }
              });
            },
            inputFormatters: [integerformat],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              fillColor: Colors.blue.shade100,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
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

class Participants extends StatefulWidget {
  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (iChoosePartcpnts == true)
        Text('You will choose participants between applied people'),
      if (iChoosePartcpnts == false)
        Text('First applied people will  participate in the project'),
      Switch(
        value: iChoosePartcpnts,
        onChanged: (value) {
          setState(() {
            iChoosePartcpnts = value;
          });
        },
        activeTrackColor: Colors.yellow,
        activeColor: Colors.orangeAccent,
      ),
    ]);
  }
}

class HaveMessage extends StatefulWidget {
  @override
  _HaveMessageState createState() => _HaveMessageState();
}

class _HaveMessageState extends State<HaveMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (haveMessage == false)
        Row(
          children: [
            Flexible(
                child: Text(
                    'Do you have a message to people applied to your project')),
            Switch(
              value: haveMessage,
              onChanged: (value) {
                setState(() {
                  haveMessage = value;
                });
              },
              activeTrackColor: Colors.yellow,
              activeColor: Colors.orangeAccent,
            ),
          ],
        ),
      if (haveMessage == true)
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                      'The message below will be shown to the people appliying to your project'),
                ),
                Switch(
                  value: haveMessage,
                  onChanged: (value) {
                    setState(() {
                      haveMessage = value;
                    });
                  },
                  activeTrackColor: Colors.yellow,
                  activeColor: Colors.orangeAccent,
                ),
              ],
            ),
            SizedBox(
              height: 240,
              child: Form(
                  child: TextFormField(
                maxLines: null,
                minLines: null,
                expands: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note_add),
                  hintText: 'Your message...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onChanged: (val) {
                  message = val;
                },
              )),
            ),
          ],
        ),
    ]);
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
