import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenaction/authentication.dart';
import 'package:greenaction/models/sidedrawer.dart';
import 'package:greenaction/models/user.dart';
import 'package:greenaction/pages/projectlists.dart';
import 'package:greenaction/test/testpage1.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user;
  DocumentSnapshot usersnapshot;
  String exampletext = '';
  String uid = CustomAuthentication().getUID();
  List<String> liste1 = ['kjsa', 'aksjcn', 'kasj', 'asjg'];
  List<String> liste2 = ['kjsa', 'aksjcn', 'kasj', 'asjg'];
  List<String> liste3 = ['kjsa', 'aksjcn', 'kasj', 'asjg'];

  @override
  Widget build(BuildContext context) {
    /* List<List> list = [liste1, liste2, liste3];
    List<dynamic> finallist = [list, 'somethinoefol'];
    String jsonencoded = jsonEncode(finallist);
    FirebaseFirestore fire = FirebaseFirestore.instance;
    Map<String, dynamic> map = {'questions': jsonencoded};
    fire
        .collection('CreatedProjects201x')
        .doc('TkFOCWtjmWVS7aZtQdA8IMtsekz2_1')
        .update(map);
    print(jsonencoded);
    List jdecoded = jsonDecode(jsonencoded);

    print(jdecoded);*/
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: SideDrawer(),
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
            Column(
              children: [
                Container(
                  child: Text('News'),
                ),
                IconButton(
                    icon: Icon(Icons.alarm),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TestPageOne(
                                    user: user,
                                  )));
                    }),
              ],
            ),
            Container(
              child: Text('Chat'),
            ),
            FutureBuilder<User>(
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
                  return ProjeLists(user: snapshot.data);
                }
                return SizedBox(
                    height: 20,
                    child: Center(child: CircularProgressIndicator()));
              },
              future: getuser(uid),
            )
          ],
        ),
      ),
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
