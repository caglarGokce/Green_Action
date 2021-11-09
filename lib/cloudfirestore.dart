import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenaction/authentication.dart';
//import 'package:greenaction/localStore.dart';

class FireStore {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool exist = true;
  bool invitedBy = false;
/*
//gets data from firebase and saves file to appDir
  Future<void> getDataFromFB() async {
    String uid = CustomAuthentication().getUID();
    try {
      DocumentSnapshot ds =
          await _firestore.collection('GoodGreenUsers').doc(uid).get();
      String name = ds['name'];
      String location = ds['location'];
      String motto = ds['motto'];
      await LocalStore().saveFile(name, location, motto);
    } catch (e) {
      getDataFromFB();
    }
  }

  void uploadDatatoFB(location, name, motto) async {
    String uid = CustomAuthentication().getUID();

    Map<String, dynamic> data = {
      'location': location,
      'name': name,
      'motto': motto,
    };
    await _firestore.collection('GoodGreenUsers').doc(uid).update(data);
    LocalStore().saveFile(name, location, motto);
  }
*/
  void uploadFieldstoFB(email, uid) async {
    print('uploadfieldstoFB called');

    bool fieldsUploaded = await CustomAuthentication().fieldUploader();
    print('uploadfieldstoFB called after await');
    if (fieldsUploaded == false) {
      await checkDoc(uid);

      if (exist == false) {
        Map<String, dynamic> data = {
          'email': email,
          'location': 'Somewhere',
          'name': 'Anonymus',
          'invitedPeople': '',
          'invitedBy': '',
          'motto': 'Hello Green!',
          'uid': uid,
          'appliedProjects': [],
          'organizedProjects': []
        };
        await _firestore
            .collection('GoodGreenUsers')
            .doc(uid)
            .set(data, SetOptions(merge: true));
        var doc = await _firestore.collection('GoodGreenUsers').doc(uid).get();
        if (doc.exists == true) {
          print('Users field filled');

          CustomAuthentication().sharedPrefSetTrue();
        } else {
          uploadFieldstoFB(email, uid);
          print('uploadFiledstoFB called again');
        }
      }
    } else {
      print('Userfield filled is true');
    }
  }

  Future<void> uploadInvitingUsersMail(String email) async {
    bool fieldsUploaded = await CustomAuthentication().inviterEmailUploader();
    if (fieldsUploaded == false) {
      String myEmail = CustomAuthentication().getEmail();
      String uid = CustomAuthentication().getUID();
      bool booly = false;
      QuerySnapshot qs;
      var ds;
      await checkinvitation(uid);
      if (invitedBy == false) {
        if (email == myEmail) {
          print('please enter another email');
        } else {
          try {
            qs = await _firestore
                .collection('GoodGreenUsers')
                .where('email', isEqualTo: email)
                .get();
            ds = qs.docs
                .map((e) => e.id)
                .reduce((value, element) => value + element);
            booly = true;
          } catch (e) {
            print('email doesnt exist');
          }
          if (booly == true) {
            await _firestore.collection('GoodGreenUsers').doc(ds).update({
              'invitedPeople': FieldValue.arrayUnion([myEmail])
            });
            await _firestore
                .collection('GoodGreenUsers')
                .doc(uid)
                .update({'invitedBy': email});
            await _firestore
                .collection('GoodGreenUsers')
                .doc('inv:$uid')
                .set({});
            var gs = await _firestore
                .collection('GoodGreenUsers')
                .doc('inv:$uid')
                .get();
            if (gs.exists == true) {
              CustomAuthentication().inviterPrefSetTrue();
            } else {
              uploadInvitingUsersMail(email);
            }
          }
        }
      } else {
        print('invitation exist');
      }
    } else {
      print('inviteruploaded is true');
    }
  }

  Future<void> checkinvitation(String uid) async {
    bool fieldsUploaded = await CustomAuthentication().inviterEmailUploader();
    if (fieldsUploaded == false) {
      if (invitedBy == false) {
        var collectionRef = _firestore.collection('GoodGreenUsers');

        var doc = await collectionRef.doc('inv:$uid').get();
        invitedBy = doc.exists;
        if (invitedBy == true) {
          CustomAuthentication().inviterPrefSetTrue();
        }
        print('invited value assigned: $invitedBy');
      }
    } else {
      print('inviterUploaded is true');
    }
  }

  Future<void> checkDoc(String uid) async {
    print('checkDoc called: checkDoc called');
    bool fieldsUploaded = await CustomAuthentication().fieldUploader();
    if (fieldsUploaded == false) {
      var collectionRef = _firestore.collection('GoodGreenUsers');

      var doc = await collectionRef.doc(uid).get();
      exist = doc.exists;
      if (exist == true) {
        CustomAuthentication().sharedPrefSetTrue();
      }
      print('checkDoc called: exist value assigned: $exist');
    } else {
      print('checkDoc called: fieldsUploaded is true');
    }
  }

  Future<String> createProjectId() async {
    print('createProjectId called');
    int i = 0;
    bool returnBool = false;

    while (returnBool == false) {
      print('in the while $i');
      i++;
      var doc = await _firestore
          .collection('CreatedProjects201x')
          .doc('${CustomAuthentication().getUID()}_$i')
          .get();
      if (!doc.exists) {
        print('!doc doesnt exist $i');
        returnBool = true;
      }
    }
    print('exit while');
    return '${CustomAuthentication().getUID()}_$i';
  }

  Future<Map> setProjectNo() async {
    print('setProjectNo called');
    DocumentSnapshot ds = await _firestore
        .collection('projectNo')
        .doc('t21q4KJyZZNJvXlcmJWk')
        .get();
    var no = ds['projectno'];

    no++;

    Map<String, dynamic> data = {
      'projectno': no,
    };

    _firestore.collection('projectNo').doc('t21q4KJyZZNJvXlcmJWk').update(data);
    return data;
  }
}
