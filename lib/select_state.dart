import 'package:besafe/Json/across_india.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Json/affectedData.dart';
import 'Json/districts.dart';
import 'Json/districtzone.dart';
import 'Json/stateslist.dart';
import 'covid_status.dart';
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

  static final acrossIndiaUrl = 'https://api.covid19india.org/data.json';
  //

  //Api Data store
  List<StatesInIndia> stateInfo;
  List<AffectedData> affectedData;
  List<StateNameOfDistricts> affectedDistricts;
  List<DistrictZone> affectedDistrictZoneData;
  int affectedDataLength;
  List<String> dropDown = new List<String>();
  String selectedState;
  AcrossIndia todayData;

  //

  //Parsing AcrossIndia data
  Future<AcrossIndia> getAcrossIndiaStats() async {
    var response = await http.get(acrossIndiaUrl);
    var list = json.decode(response.body);
    var lengthOfStats = list['cases_time_series'].length;
    AcrossIndia today =
        AcrossIndia.fromJson(list['cases_time_series'][lengthOfStats - 1]);
    return today;
  }
  //Parsing ends

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
            getAcrossIndiaStats().then((value) {
              todayData = value;
              setState(() {
                isLoading = false;
              });
            });
          });
        });
      });
    });
  }

  //UI Starts here

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.orangeAccent,
        body: !isLoading
            ? CustomScrollView(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text(
                      'BeSafe',
                      style: TextStyle(color: Colors.black),
                    ),
                    elevation: 4,
                    backgroundColor: Colors.amberAccent,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height * .25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width * .7,
                                  decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Across India status',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      //---------------- Contains 3 container for each cases
                                      Container(
                                          padding: EdgeInsets.all(4),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .26,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .17,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 4, color: Colors.red),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  todayData.totalconfirmed,
                                                  style: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.red,
                                                        size: 24.0,
                                                      ),
                                                      Text(
                                                        todayData
                                                            .dailyconfirmed,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Positive',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(4),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .26,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .17,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 4,
                                                color: Colors.green,
                                              )),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  todayData.totalrecovered,
                                                  style: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.green,
                                                        size: 24.0,
                                                      ),
                                                      Text(
                                                        todayData
                                                            .dailyconfirmed,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Recovered',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(4),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .26,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .17,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              width: 4,
                                              color: Color.fromARGB(
                                                  255, 217, 69, 95),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  todayData.totaldeceased,
                                                  style: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.arrow_upward,
                                                        color: Color.fromARGB(
                                                            255, 217, 69, 95),
                                                        size: 24.0,
                                                      ),
                                                      Text(
                                                        todayData
                                                            .dailyconfirmed,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Deceased',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate.fixed(<Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Report',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .2),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Precautions',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Text(
                          'Select State for more information',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: stateSelectList(),
                        ),
                      ),
                    ]),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  //Using stateInfo Object to display state details in list

  stateSelectList() {
    List<Widget> temp = [];
    for (var i = 0; i < stateInfo.length; i++) {
      temp.add(
        InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            int tempidx = i;
            print('OnTap ListTile ${stateInfo[i]}');
            if (stateInfo[i].name == 'Dadra and Nagar Haveli') {
              tempidx += 1;
            }
            print('State selected ${stateInfo[tempidx].name}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CovidStatus(
                  index: i,
                  affectedData: affectedData,
                  stateChosen: stateInfo[tempidx],
                  districtsAffected: affectedDistricts,
                  districtZone: affectedDistrictZoneData,
                ),
              ),
            );
          },
          child: Container(
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.only(
                top: 4,
                left: 10,
                right: 10,
              ),
              padding: EdgeInsets.only(
                left: 2,
                top: 3,
                bottom: 2,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black45, width: 2),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      stateInfo[i].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    }
    return temp;
  }
}
