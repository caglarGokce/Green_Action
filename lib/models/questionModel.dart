import 'dart:convert';

import 'package:greenaction/models/projectModel.dart';

class Question {
  String question;
  //List<Answer> answers;
  String answers;
  int answerCounter;
  String date;
  String whoisAsking;

  Question(
      {this.question,
      this.answers,
      this.answerCounter = 0,
      this.date,
      this.whoisAsking});

  String toJson() {
    Map<String, dynamic> map = {
      'whoisAsking': whoisAsking,
      'question': question,
      'answers': answers,
      'answerCounter': answerCounter,
      'date': date
    };
    return jsonEncode(map);
  }

  List formJson(ProjectModel proje) {
    return jsonDecode(proje.questions);
  }

  factory Question.fromFirestore(Map map) {
    return Question(
        question: map['question'],
        answers: map['answers'],
        answerCounter: map['answerCounter'],
        date: map['date']);
  }

//projeden question Stringini al
//question stringini jsencode ile map e cevir
//map i Question objesine cevir
//question objesi icinde answer stringini jsencode yap ve mape cevir
//mapi answer objesine cevir
//
}
