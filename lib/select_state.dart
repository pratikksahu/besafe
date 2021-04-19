import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Json/affectedData.dart';
import 'Json/districts.dart';
import 'Json/districtzone.dart';
import 'Json/stateslist.dart';
import 'covid_status.dart';
import 'services/auth_service.dart';
import 'dart:convert';
import 'dart:async';

class SelectState extends StatefulWidget {
  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  bool isLoading = true;

//API
  static final stateUrl =
      'https://raw.githubusercontent.com/Dhaneshmonds/webiste-utilities/master/state-districts.json';
  static final stateAffectedUrl =
      'https://api.covid19india.org/states_daily.json';
  static final districtUrl =
      'https://api.covid19india.org/districts_daily.json';
  static final districtZoneUrl = 'https://api.covid19india.org/zones.json';
  //

  List<StatesInIndia> stateInfo;
  List<AffectedData> affectedData;
  List<StateNameOfDistricts> affectedDistricts;
  List<DistrictZone> affectedDistrictZoneData;
  int affectedDataLength;
  List<String> dropDown = new List<String>();
  String selectedState;

  //Parsing District zone

  Future<List<DistrictZone>> getDistrictZone() async {
    var response = await http.get(districtZoneUrl);
    List<DistrictZone> zoneList = parseZone(response);
    return zoneList;
  }

  static List<DistrictZone> parseZone(response) {
    var list = json.decode(response.body);
    List<DistrictZone> temp = [];
    list['zones'].forEach((element) {
      temp.add(DistrictZone.fromJson(element));
    });
    return temp;
  }

  //Parsing ends

//Parsing State List
  Future<List<StatesInIndia>> getStates() async {
    var response = await http.get(stateUrl);
    List<StatesInIndia> stateList = parseState(response);
    return stateList;
  }

  static List<StatesInIndia> parseState(jsonData) {
    var list = json.decode(jsonData.body);
    return list['states']
        .map<StatesInIndia>((obj) => StatesInIndia.fromJson(obj))
        .toList();
  }
  //Parsing ends

  //Parsing Affected People in states

  Future<List<AffectedData>> getAffected() async {
    var response = await http.get(stateAffectedUrl);
    List<AffectedData> affectedDataList = parseAffectedData(response);
    return affectedDataList;
  }

  static List<AffectedData> parseAffectedData(jsonData) {
    var list = json.decode(jsonData.body);
    return list['states_daily']
        .map<AffectedData>((obj) => AffectedData.fromJson(obj))
        .toList();
  }

  //Parsing ends

  //Parsing district affected
  Future<List<StateNameOfDistricts>> getDistrictAffected() async {
    var response = await http.get(districtUrl);
    var list = json.decode(response.body);
    List<StateNameOfDistricts> affectedDistricList =
        new List<StateNameOfDistricts>();
    list['districtsDaily'].forEach((stateName, dictrictObj) {
      affectedDistricList
          .add(parseAffectedDistrictData(stateName, dictrictObj));
    });
    return affectedDistricList;
  }

  static StateNameOfDistricts parseAffectedDistrictData(
      individualStateName, districtDetailObj) {
    StateNameOfDistricts obj =
        StateNameOfDistricts.fromJson(individualStateName, districtDetailObj);
    return obj;
  }

  //Parsing ends

  @override
  void initState() {
    super.initState();
    getStates().then((value) {
      stateInfo = value;
      getAffected().then((value) {
        affectedData = value;
        affectedDataLength = affectedData.length;
        getDistrictAffected().then((value) {
          affectedDistricts = value;
          getDistrictZone().then((value) {
            affectedDistrictZoneData = value;
            setState(() {
              isLoading = false;
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select State'),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                await AuthService()
                    .signOut()
                    .then((value) => Navigator.pop(context));
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
        body: !isLoading
            ? stateSelectList()
            : Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  stateSelectList() {
    return ListView.builder(
      itemCount: stateInfo.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            int tempidx = index;
            print('OnTap ListTile ${stateInfo[index]}');
            if (stateInfo[index].name == 'Dadra and Nagar Haveli') {
              tempidx += 1;
            }
            print('State selected ${stateInfo[tempidx].name}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CovidStatus(
                  index: index,
                  affectedData: affectedData,
                  stateChosen: stateInfo[tempidx],
                  districtsAffected: affectedDistricts,
                  districtZone: affectedDistrictZoneData,
                ),
              ),
            );
          },
          title: Text(stateInfo[index].name),
        );
      },
    );
  }
}
