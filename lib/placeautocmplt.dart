import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

String location = '';

class LocationFinder extends StatefulWidget {
  @override
  _LocationFinderState createState() => _LocationFinderState();
  String getLocation() {
    print(location);
    return location;
  }
}

class _LocationFinderState extends State<LocationFinder> {
  List<AutocompletePrediction> predictions = [];
  var googlePlace = GooglePlace("AIzaSyAOsUWzRuAlMOIZNh0_E2hGQipc1zBNARQ");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('green'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Search",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                autoCompleteSearch(value);
              } else {
                if (predictions.length > 0 && mounted) {
                  setState(() {
                    predictions = [];
                    print(predictions);
                  });
                }
              }
            },
          ),
          SearchAdressWidget(predictions: predictions),
        ],
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}

class SearchAdressWidget extends StatelessWidget {
  const SearchAdressWidget({
    @required this.predictions,
  });

  final List<AutocompletePrediction> predictions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Icon(
                Icons.pin_drop,
                color: Colors.white,
              ),
            ),
            title: Text(predictions[index].description),
            onTap: () {
              location = predictions[index].description;
              debugPrint(predictions[index].placeId);
              Navigator.pop(context, location);
            },
          );
        },
      ),
    );
  }
}
