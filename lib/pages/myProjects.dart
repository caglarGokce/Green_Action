import 'package:flutter/material.dart';

class MyProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, //tab count
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: TabBar(
            unselectedLabelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text('My Projects'),
              ),
              Tab(
                child: Text('Joined Projects'),
              ),
              Tab(
                child: Text('Past Projects'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Text('My Projects'),
            ),
            Container(
              child: Text('Joined Projects'),
            ),
            Container(
              child: Text('Past Projects'),
            ),
          ],
        ),
      ),
    );
  }
}
