//import 'dart:convert';
/*
import 'package:greenaction/authentication.dart';
import 'package:greenaction/cloudfirestore.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
*/
//class LocalStore {
  /*Future<Map> getFilePath() async {
    print('getfilePath function called');
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    if (await File(
            '${appDocumentsDirectory.path}/profileinfoof${CustomAuthentication().getUID()}.txt')
        .exists()) {
      print('getfilePath: file path exists');
      File file = File(
          '${appDocumentsDirectory.path}/profileinfoof${CustomAuthentication().getUID()}.txt');
      Map map = jsonDecode(await readFile(file));
      print(readFile(file));
      return map;
    } else {
      final _preferences = await SharedPreferences.getInstance();
      final initialBool =
          _preferences.getBool('first${CustomAuthentication().getUID()}');
      if (initialBool == false) {
        //get data from FB
        print('getfilePath: file path used first time');

        CustomAuthentication().firstPrefSetTrue();

        //await FireStore().getDataFromFB();

        File file = File(
            '${appDocumentsDirectory.path}/profileinfoof${CustomAuthentication().getUID()}.txt');
        Map map = jsonDecode(await readFile(file));
        return map;
      }
      print('getfilePath: file path does not exist');

      File file = await File(
              '${appDocumentsDirectory.path}/profileinfoof${CustomAuthentication().getUID()}.txt')
          .writeAsString(createDefaultMap());
      Map map = jsonDecode(await readFile(file));
      return map;
    }
  }*/
/*
  Future saveFile(String name, String location, String motto) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    File file = File(
        '${appDocumentsDirectory.path}/profileinfoof${CustomAuthentication().getUID()}.txt'); // 1
    file.writeAsString(convertProfileToJString(name, location, motto)); // 2
    print('saveFile Called');
  }
*/ /*
  Future<String> readFile(file) async {
    String fileContent = await file.readAsString(); // 2
    print('readFile: $fileContent');
    return fileContent;
  }

  String convertProfileToJString(String name, String location, String motto) {
    Map<String, dynamic> profile = {
      'name': name,
      'location': location,
      'motto': motto,
    };

    String returnableProfile = jsonEncode(profile);
    print('convertProfileToString: $returnableProfile');
    return returnableProfile;
  }

  String createDefaultMap() {
    Map<String, dynamic> data = {
      'location': 'Somewhere',
      'name': 'Anonymus',
      'motto': 'Hello Green!',
    };

    String returnableMap = jsonEncode(data);
    print('createDefaultMap: $returnableMap');

    return returnableMap;
  }*/
//}
