import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String email;
  String location;
  String name;
  String motto;
  List invitedPeople;
  String invitedBy;
  //List likes;
  //List dislikes;
  //List myComments;
  //List myQuestions;
  List appliedProjects;

  User(
      {this.uid,
      this.appliedProjects,
      //    this.dislikes,
      this.email,
      this.invitedBy,
      this.invitedPeople,
      //    this.likes,
      this.location,
      this.motto,
      //    this.myComments,
      //    this.myQuestions,
      this.name});

  Map<String, dynamic> toMap() => {
        //    'likes': likes,
        //    'dislikes': dislikes,
        'name': name,
        'email': email,
        'uid': uid,
        'appliedProjects': appliedProjects,
        'invitedPeople': invitedPeople,
        'invitedBy': invitedBy,
        'location': location,
        'motto': motto,
        //    'myComments': myComments,
        //    'myQuestions': myQuestions
      };

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map map = doc.data();

    return User(
      //    likes: map['likes'],
      //    dislikes: map['dislikes'],
      name: map['name'],
      email: map['email'],
      uid: map['uid'],
      appliedProjects: map['appliedProjects'],
      invitedBy: map['invitedBy'],
      invitedPeople: map['invitedPeople'],
      location: map['location'],
      motto: map['motto'],
      //    myComments: map['myComments'],
      //    myQuestions: map['myQuestions']
    );
  }
  User dataFromUserSnapshot(DocumentSnapshot snapshot) {
    User user = User.fromFirestore(snapshot);

    return user;
  }
}
