import 'package:flutter/material.dart';
import 'package:greenaction/models/user.dart';

// ignore: must_be_immutable
class TestPageThree extends StatefulWidget {
  User user;
  TestPageThree({this.user});

  @override
  _TestPageThreeState createState() => _TestPageThreeState(user);
}

class _TestPageThreeState extends State<TestPageThree> {
  User user;

  _TestPageThreeState(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page Three'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  user.name = 'some other name';
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
