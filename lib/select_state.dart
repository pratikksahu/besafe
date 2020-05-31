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
        // backgroundColor: Colors.orangeAccent,
        body: !isLoading
            ? CustomScrollView(
                // physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text('BeSafe'),
                    elevation: 4,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * .25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  'Across India status',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      width: MediaQuery.of(context).size.width *
                                          .26,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          top: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Confirmed')),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      width: MediaQuery.of(context).size.width *
                                          .26,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Recovered')),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      width: MediaQuery.of(context).size.width *
                                          .26,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          'Active',
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
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
        Container(
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
                bottom: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: InkWell(
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
                alignment: Alignment.centerLeft,
                child: Text(
                  stateInfo[i].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )),
      );
    }
    return temp;
  }
}
