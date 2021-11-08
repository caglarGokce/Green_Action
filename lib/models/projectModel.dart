import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenaction/models/questionModel.dart';

class ProjectModel {
  final String headline;
  final String shortdetail;
  final String projectdetails;
  final String starting;
  final String deadline;
  final String prize;
  final dynamic photo;
  final String location;
  final String minnumberofparticipants;
  final String maxnumberofparticipants;
  final String contactinfo;
  final String projectid;
  final File photoforFB;
  final bool commentsOn;
  final bool questionsOn;
  final String questions;
  final List comments;
  final bool isPhotoUploaded;
  final String organizedBy;
  final bool isActive;
  final int likes;
  final int dislikes;
  final String launchdate;
  final int views;
  final List applicants;
  final List participants;
  final bool iChoosePartcpnts;
  final bool haveMessage;
  final String message;

  const ProjectModel(
      {this.comments,
      this.haveMessage,
      this.message,
      this.iChoosePartcpnts = true,
      this.participants,
      this.applicants,
      this.views = 0,
      this.launchdate,
      this.likes = 0,
      this.dislikes = 0,
      this.isActive = true,
      this.organizedBy,
      this.isPhotoUploaded = false,
      this.questions = '',
      this.projectid,
      this.commentsOn = true,
      this.questionsOn = true,
      this.photoforFB,
      this.photo,
      this.deadline,
      this.headline,
      this.location,
      this.maxnumberofparticipants,
      this.minnumberofparticipants,
      this.prize,
      this.shortdetail,
      this.starting,
      this.projectdetails,
      this.contactinfo});

  Map<String, dynamic> toMap() => {
        'haveMessage': haveMessage,
        'message': message,
        'participants': participants,
        'iChoosePartcpnts': iChoosePartcpnts,
        'applicants': applicants,
        'views': views,
        'likes': likes,
        'dislikes': dislikes,
        'launchdate': launchdate,
        'isActive': isActive,
        'organizedBy': organizedBy,
        'isPhotoUploaded': isPhotoUploaded,
        'commentsOn': commentsOn,
        'questionsOn': questionsOn,
        'comments': comments,
        'questions': questions,
        'deadline': deadline,
        'headline': headline,
        'location': location,
        'maxnumberofparticipants': maxnumberofparticipants,
        'minnumberofparticipants': minnumberofparticipants,
        'prize': prize,
        'shortdetail': shortdetail,
        'starting': starting,
        'projectdetails': projectdetails,
        'contactinfo': contactinfo,
        'projectid': projectid
      };
  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    Map map = doc.data();

    return ProjectModel(
        haveMessage: map['haveMessage'],
        message: map['message'],
        iChoosePartcpnts: map['iChoosePartcpnts'],
        participants: map['participants'],
        applicants: map['applicants'],
        views: map['views'],
        likes: map['likes'],
        dislikes: map['dislikes'],
        isActive: map['isActive'],
        organizedBy: map['organizedBy'],
        isPhotoUploaded: map['isPhotoUploaded'],
        commentsOn: map['commentsOn'],
        questionsOn: map['questionsOn'],
        comments: map['comments'],
        questions: map['questions'],
        deadline: map['deadline'],
        headline: map['headline'],
        location: map['location'],
        maxnumberofparticipants: map['maxnumberofparticipants'],
        minnumberofparticipants: map['minnumberofparticipants'],
        shortdetail: map['shortdetail'],
        starting: map['starting'],
        projectdetails: map['projectdetails'],
        projectid: map['projectid'],
        contactinfo: map['contactinfo'],
        prize: map['prize']);
  }
  List<ProjectModel> dataFromSnapShots(List<DocumentSnapshot> snapshot) {
    List<ProjectModel> projeler = [];
    for (DocumentSnapshot item in snapshot) {
      ProjectModel ds = ProjectModel.fromFirestore(item);

      projeler.add(ds);
    }

    return projeler;
  }

  ProjectModel datafromdocument(DocumentSnapshot snapshot) {
    ProjectModel proje = ProjectModel.fromFirestore(snapshot);
    return proje;
  }

  List<Question> getQuestionListfromDocSnapshot(DocumentSnapshot ds) {
    ProjectModel proje = ProjectModel.fromFirestore(ds);
    List<Question> questionlist = [];
    if (proje.questions == '') {
      return [];
    } else {
      List list = jsonDecode(proje.questions);
      for (var item in list) {
        Question question = Question.fromFirestore(jsonDecode(item));
        print('questiondate${question.date}');
        questionlist.add(question);
      }
    }
    // print(jsonDecode(proje.questions));
    // print(jsonDecode(proje.questions)[0]);
    // print(jsonDecode(jsonDecode(proje.questions)[0]));
    // print(jsonDecode(jsonDecode(proje.questions)[0])['date']);
    return questionlist;
  }

  List<Question> getQuestionListfromProjectModel(ProjectModel proje) {
    List<Question> questionlist = [];
    if (proje.questions == '') {
      return [];
    } else {
      List list = jsonDecode(proje.questions);
      for (var item in list) {
        Question question = Question.fromFirestore(jsonDecode(item));
        print('questiondate${question.date}');
        questionlist.add(question);
      }
    }
    return questionlist;
  }
}

  //final bool anonymus;

  ////change likes to dislikes

 //// change dislikes to likes
 //final bool followproject;
 //final int supportedBy;

 
 // final bool isActive;
 //  final int likes;
 // final int dislikes;
 // final String launchdate;
 // final int views;

