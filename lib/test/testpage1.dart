import 'package:flutter/material.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/test/testpage2.dart';

// ignore: must_be_immutable
class TestPageOne extends StatefulWidget {
  User user;
  TestPageOne({this.user});

  @override
  _TestPageOneState createState() => _TestPageOneState(user);
}

class _TestPageOneState extends State<TestPageOne> {
  User user;

  _TestPageOneState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page One'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestPageTwo(
                                user: user,
                              )));
                }),
            SizedBox(
              height: 20,
            ),
            Text(user.name),
            SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text('set state'))
          ],
        ),
      ),
    );
  }
}
