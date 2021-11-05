/*
class Listeleme {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> projeler = [];
  List<ProjectModel> projectslist = [];

  int documentLimit = 2;
  DocumentSnapshot lastDocument;
  QuerySnapshot querySnapshot;

  projelistesiAl() async {
    print('projelistesiAl has been called');
    if (lastDocument == null) {
      print('projelistesiAl if condition');

      querySnapshot = await firestore
          .collection('CreatedProjects201x')
          .limit(documentLimit)
          .get();
    } else {
      print('projelistesiAl else condition');

      querySnapshot = await firestore
          .collection('CreatedProjects201x')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
    }

    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    print(lastDocument['headline']);
    projeler.addAll(querySnapshot.docs);
    print('projeler $projeler');
    projectslist = ProjectModel().dataFromSnapShots(projeler);
    return projectslist;
  }
}
*/