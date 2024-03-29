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
bool projectstartcheckbox6 = true;
bool projectstartcheckbox7 = true;
bool projectstartcheckbox8 = true;
bool projectstartcheckbox9 = true;
int numberofparticipants = 0;
int amountofdonation = 0;
bool projectstartbetweencheckbox = true;
int begininint = 0;
String begininstring = 'day';
int begininint1 = 0;
String begininstring1 = 'day';
int priorint = 0;
String priorstring = 'day';
int priorint1 = 0;
String priorstring1 = 'day';
String dropdownValueprior = 'day';
String dropdownValuebeginin = 'day';
String inafterstring = 'in';
String deadlinestring = 'day';
int deadlineint = 0;
int notifyint = 0;
String notifystring = 'day';
bool projectfinishcheckbox = true;
bool projectfinishcheckbox1 = true;
bool projectfinishcheckbox2 = true;
bool projectfinishcheckbox3 = true;
bool projectfinishcheckbox4 = true;
bool projectfinishcheckbox5 = true;

List<DropdownMenuItem<String>> list = [
  DropdownMenuItem(
    child: Text('day'),
    value: 'day',
  ),
  DropdownMenuItem(
    child: Text('week'),
    value: 'week',
  ),
  DropdownMenuItem(
    child: Text('month'),
    value: 'month',
  ),
  DropdownMenuItem(
    child: Text('year'),
    value: 'year',
  )
];
List<DropdownMenuItem<String>> list1 = [
  DropdownMenuItem(
    child: Text('in'),
    value: 'in',
  ),
  DropdownMenuItem(
    child: Text('after'),
    value: 'after',
  ),
];

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
        //TODO projects in few sessions??
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

class ProjFinishDate extends StatefulWidget {
  const ProjFinishDate({
    Key key,
    @required this.projectdeadline,
  }) : super(key: key);

  final TextEditingController projectdeadline;

  @override
  _ProjFinishDateState createState() => _ProjFinishDateState();
}

class _ProjFinishDateState extends State<ProjFinishDate> {
  TextEditingController projectfinishbetween1 = TextEditingController();
  TextEditingController projectfinishbetween2 = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Is there a certain finish time for the project?'),
        Row(children: [
          if (projectfinishcheckbox == true) Text('Yes,there is'),
          if (projectfinishcheckbox == false) Text("No, there isn't"),
          Switch(
            value: projectfinishcheckbox,
            onChanged: (value) {
              setState(() {
                projectfinishcheckbox = value;
              });
            },
            activeTrackColor: Colors.yellow,
            activeColor: Colors.orangeAccent,
          ),
        ]),
        if (projectfinishcheckbox == true)
          //project finishes on a certain date or in a certain time interval
          Column(
            children: [
              Text(
                  'Does project finish on certain date or in a certain time interval'),
              Row(children: [
                if (projectfinishcheckbox1 == true)
                  Text('Finishes on a certain date'),
                if (projectfinishcheckbox1 == false)
                  Text("Finishes in a certain time interval "),
                Switch(
                  value: projectfinishcheckbox1,
                  onChanged: (value) {
                    setState(() {
                      projectfinishcheckbox1 = value;
                    });
                  },
                  activeTrackColor: Colors.yellow,
                  activeColor: Colors.orangeAccent,
                ),
              ]),
              if (projectfinishcheckbox1 == false)
                //project finishes in a certain time interval+++++
                Column(
                  children: [
                    Text('Project may finish between '),
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
                        projectfinishbetween1.text =
                            Hesapla.dateTimeToString(_projectDate);
                      },
                      controller: projectfinishbetween1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.note_add),
                        hintText: 'project may finish...',
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
                        projectfinishbetween2.text =
                            Hesapla.dateTimeToString(_projectDate);
                      },
                      controller: projectfinishbetween2,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.note_add),
                        hintText: 'project may finish...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )),
                  ],
                ),
              if (projectfinishcheckbox1 == true)
                //project has a certain finish date+++++++
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
                        widget.projectdeadline.text =
                            Hesapla.dateTimeToString(_projectDate);
                      },
                      controller: widget.projectdeadline,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.note_add),
                        hintText: 'project finish date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )),
                  ],
                ),
            ],
          ),
        if (projectfinishcheckbox == false)
          //there is no certain finish time of the project
          Column(
            children: [
              Text('Is there a deadline for the project?'),
              Row(children: [
                if (projectfinishcheckbox2 == true) Text('Yes,there is'),
                if (projectfinishcheckbox2 == false) Text("No, there isn't"),
                Switch(
                  value: projectfinishcheckbox2,
                  onChanged: (value) {
                    setState(() {
                      projectfinishcheckbox2 = value;
                    });
                  },
                  activeTrackColor: Colors.yellow,
                  activeColor: Colors.orangeAccent,
                ),
              ]),
              if (projectfinishcheckbox2 == true) Deadline(),
              if (projectfinishcheckbox2 == false)
                Column(
                  children: [
                    Row(children: [
                      if (projectfinishcheckbox3 == true)
                        Text('The project has no end'),
                      if (projectfinishcheckbox3 == false)
                        Text(
                            'I will inform participants about the end of project'),
                      Switch(
                        value: projectfinishcheckbox3,
                        onChanged: (value) {
                          setState(() {
                            projectfinishcheckbox3 = value;
                          });
                        },
                        activeTrackColor: Colors.yellow,
                        activeColor: Colors.orangeAccent,
                      ),
                    ]),
                    if (projectfinishcheckbox3 == false) NotifyFinish()
                  ],
                )
            ],
          )
      ],
    );
  }
}

class NotifyFinish extends StatefulWidget {
  @override
  _NotifyFinishState createState() => _NotifyFinishState();
}

class _NotifyFinishState extends State<NotifyFinish> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  String _value = notifystring;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            'I will notify participants $notifyint $notifystring before the end of the project'),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    notifyint = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  notifystring = _value;
                });
              },
            )
          ],
        )
      ],
    );
  }
}

class Deadline extends StatefulWidget {
  @override
  _DeadlineState createState() => _DeadlineState();
}

class _DeadlineState extends State<Deadline> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  String _value = deadlinestring;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Project must finish in $deadlineint $deadlinestring'),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    deadlineint = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  deadlinestring = _value;
                });
              },
            )
          ],
        )
      ],
    );
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
  TextEditingController controllerpriorint = TextEditingController();
  TextEditingController controllerbegininint = TextEditingController();
  TextEditingController controllerbegininstring = TextEditingController();
  TextEditingController controllerpriorinstring = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          'Do you want project to start  as soon as you launch it?\n (You can also choose this if you have an already ongoing project)'),
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
            Text('Does your project have a certain starting time?'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Your project starts on a certain date or may start in a certain time interval?'),
                  Row(children: [
                    if (projectstartcheckbox2 == true)
                      Text('Project starts on a certain time'),
                    if (projectstartcheckbox2 == false)
                      Text('Project may start in a cetain time interval'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Project will begin after some conditions reached'),
                  Row(children: [
                    if (projectstartcheckbox6 == true) Text('Yes it will'),
                    if (projectstartcheckbox6 == false) Text("No it won't"),
                    Switch(
                      value: projectstartcheckbox6,
                      onChanged: (value) {
                        setState(() {
                          projectstartcheckbox6 = value;
                        });
                      },
                      activeTrackColor: Colors.yellow,
                      activeColor: Colors.orangeAccent,
                    ),
                  ]),
                  if (projectstartcheckbox6 == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        if (projectstartcheckbox4 == true)
                          ConditionParticipants(),
                        Text(
                            'Do you need minimum amount of donation to start this project?'),
                        Row(
                          children: [
                            if (projectstartcheckbox5 == true) Text('Yes i do'),
                            if (projectstartcheckbox5 == false)
                              Text('No i dont'),
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
                        Text('Is there another condition to reach? '),
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
                        Column(
                          children: [
                            Text(
                                'Do you want project to start immediately after the conditions reached?'),
                            Row(
                              children: [
                                if (projectstartcheckbox8 == true)
                                  Text('Yes, start project immediately'),
                                if (projectstartcheckbox8 == false)
                                  Text("No, don't start immediately"),
                                Switch(
                                  value: projectstartcheckbox8,
                                  onChanged: (value) {
                                    setState(() {
                                      projectstartcheckbox8 = value;
                                    });
                                  },
                                  activeTrackColor: Colors.yellow,
                                  activeColor: Colors.orangeAccent,
                                ),
                              ],
                            ),
                            if (projectstartcheckbox8 == false)
                              Column(
                                children: [
                                  Text(
                                      '////////////////////////////////////////////////////////////////////////////'),
                                  Row(
                                    children: [
                                      if (projectstartcheckbox9 == true)
                                        Text('The project will start in:'),
                                      if (projectstartcheckbox9 == false)
                                        Text(
                                            "I will notify participants prior to:"),
                                      Switch(
                                        value: projectstartcheckbox9,
                                        onChanged: (value) {
                                          setState(() {
                                            projectstartcheckbox9 = value;
                                          });
                                        },
                                        activeTrackColor: Colors.yellow,
                                        activeColor: Colors.orangeAccent,
                                      ),
                                    ],
                                  ),
                                  if (projectstartcheckbox9 == false)
                                    WillNotifyPrior2(),
                                  if (projectstartcheckbox9 == true)
                                    Column(
                                      children: [WillBeginIn2()],
                                    )
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  if (projectstartcheckbox6 == false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WillNotifyPrior(),
                        ),
                      ],
                    )
                ],
              ),
          ],
        )
    ]);
  }
}

class WillBeginIn2 extends StatefulWidget {
  @override
  _WillBeginIn2State createState() => _WillBeginIn2State();
}

class _WillBeginIn2State extends State<WillBeginIn2> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  String _value = begininstring1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('And then the project will begin $begininint1 $begininstring1 '),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    begininint1 = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  begininstring1 = _value;
                });
              },
            )
          ],
        )
      ],
    );
  }
}

class WillNotifyPrior2 extends StatefulWidget {
  @override
  _WillNotifyPrior2State createState() => _WillNotifyPrior2State();
}

class _WillNotifyPrior2State extends State<WillNotifyPrior2> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  String _value = priorstring1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Text('How much time prior to the start will you notify participants?'),
        //Text('I will notify $priorint1 $priorstring1 prior to the start'),
        Text('$priorint1 $priorstring1'),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    priorint1 = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  priorstring1 = _value;
                });
              },
            )
          ],
        )
      ],
    );
  }
}

class WillNotifyPrior extends StatefulWidget {
  @override
  _WillNotifyPriorState createState() => _WillNotifyPriorState();
}

class _WillNotifyPriorState extends State<WillNotifyPrior> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  String _value = priorstring;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'When will you notify participants about the project start?'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'I will notify participants $priorint $priorstring prior to the start'),
        ),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    priorint = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  priorstring = _value;
                });
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'At the end of the notification time, after $priorint $priorstring, will project start immediately or may start in an interval of some time?'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            if (projectstartcheckbox7 == true)
              Text('After $priorint $priorstring it will start immediately'),
            if (projectstartcheckbox7 == false)
              Flexible(
                child: Text(
                    'After $priorint $priorstring it may start in an interval of some time'),
              ),
            Switch(
              value: projectstartcheckbox7,
              onChanged: (value) {
                setState(() {
                  projectstartcheckbox7 = value;
                });
              },
              activeTrackColor: Colors.yellow,
              activeColor: Colors.orangeAccent,
            ),
          ]),
        ),
        if (projectstartcheckbox7 == false) WillBeginIn(),
      ],
    );
  }
}

class WillBeginIn extends StatefulWidget {
  @override
  _WillBeginInState createState() => _WillBeginInState();
}

class _WillBeginInState extends State<WillBeginIn> {
  TextEditingController controller = TextEditingController();

  TextInputFormatter integerformat =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  String _value = begininstring;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('And then the project will begin $begininint $begininstring '),
        Row(
          children: [
            Container(
              width: 60,
              height: 30,
              child: TextField(
                controller: controller,
                inputFormatters: [integerformat],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    begininint = int.parse(controller.text);
                  });
                },
              ),
            ),
            DropdownButton(
              items: list,
              value: _value,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  begininstring = _value;
                });
              },
            )
          ],
        )
      ],
    );
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
