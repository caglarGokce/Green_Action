import 'package:flutter/material.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/test/testpage3.dart';

// ignore: must_be_immutable
class TestPageTwo extends StatefulWidget {
  User user;
  TestPageTwo({this.user});

  @override
  _TestPageTwoState createState() => _TestPageTwoState(user);
}

class _TestPageTwoState extends State<TestPageTwo> {
  User user;

  _TestPageTwoState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page Two'),
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
                          builder: (context) => TestPageThree(
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
