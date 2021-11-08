import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/authentication.dart';
import 'package:greenaction/models/sidedrawer.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/projectlists.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  DocumentSnapshot usersnapshot;
  String uid = CustomAuthentication().getUID();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: FutureBuilder<User>(
          future: getuser(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return SizedBox(
                  height: 20,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return Text('error');
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                backgroundColor: Colors.white,
                drawer: SideDrawer(user: user),
                appBar: AppBar(
                  actions: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          CustomAuthentication().signOut();
                        })
                  ],
                  title: Text('Home Page'),
                  backgroundColor: Colors.green,
                  bottom: TabBar(
                    unselectedLabelColor: Colors.amber,
                    tabs: [
                      Tab(
                        child: Text('News'),
                      ),
                      Tab(
                        child: Text('Chat'),
                      ),
                      Tab(
                        child: Text('Projects'),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Container(child: Text('news')),
                    Container(
                      child: Text('Chat'),
                    ),
                    ProjeLists(user: user)
                  ],
                ),
              );
            }
            return SizedBox(
                height: 20, child: Center(child: CircularProgressIndicator()));
          }),
    );
  }

  Future<User> getuser(uid) async {
    print('user called');
    print(uid);
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    usersnapshot = await firebase.collection('GoodGreenUsers').doc(uid).get();
    user = User().dataFromUserSnapshot(usersnapshot);
    print(user.name);
    print(user.uid);
    return user;
  }
}
