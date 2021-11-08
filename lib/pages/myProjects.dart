import 'package:flutter/material.dart';
import 'package:greenaction/models/user.dart';

// ignore: must_be_immutable
class MyProjects extends StatelessWidget {
  User user;
  MyProjects({this.user});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //tab count
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          bottom: TabBar(
            unselectedLabelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text('Organized Projects'),
              ),
              Tab(
                child: Text('Applied Projects'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: 0,
                      itemBuilder: (context, item) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Card(
                            child: ListTile(),
                          ),
                        );
                      }),
                )
              ],
            ),
            Container(
              child: Text('Applied Projects'),
            ),
          ],
        ),
      ),
    );
  }
}
