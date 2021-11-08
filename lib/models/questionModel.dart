import 'dart:convert';

import 'package:greenaction/models/projectModel.dart';

class Question {
  String question;
  String answers;
  String date;
  String whoisAsking;
  bool isreplied;

  Question(
      {this.question,
      this.answers,
      this.date,
      this.whoisAsking,
      this.isreplied = false});

  String toJson() {
    Map<String, dynamic> map = {
      'whoisAsking': whoisAsking,
      'question': question,
      'answers': answers,
      'date': date,
      'isreplied': isreplied
    };
    return jsonEncode(map);
  }

  List formJson(ProjectModel proje) {
    List list = jsonDecode(proje.questions);
    if (list == null) {
      return [];
    }
    return list;
  }

  factory Question.fromFirestore(Map map) {
    return Question(
        isreplied: map['isreplied'],
        question: map['question'],
        answers: map['answers'],
        whoisAsking: map['whoisAsking'],
        date: map['date']);
  }

//projeden question Stringini al
//question stringini jsencode ile map e cevir
//map i Question objesine cevir
//question objesi icinde answer stringini jsencode yap ve mape cevir
//mapi answer objesine cevir
//
}
