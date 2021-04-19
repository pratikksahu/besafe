import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:besafe/Json/districtzone.dart';

import 'Json/affectedData.dart';
import 'Json/districts.dart';
import 'Json/stateslist.dart';

//To access State data use stateChosen object
//To access the confirmed , recovered and deceased data use ofDateSelected List and access stateCode List
//Also convert stateChose.code to lowercase
class CovidStatus extends StatefulWidget {
  final int index;
  final List<AffectedData> affectedData;
  final StatesInIndia stateChosen;
  final List<StateNameOfDistricts> districtsAffected;
  final List<DistrictZone> districtZone;

  CovidStatus({
    Key key,
    this.index,
    this.affectedData,
    this.stateChosen,
    this.districtsAffected,
    this.districtZone,
  }) : super(key: key) {
    print('CovidStatus Constructor $stateChosen');
  }

  @override
  _CovidStatusState createState() => _CovidStatusState();
}

class _CovidStatusState extends State<CovidStatus> {
  int index;
  List<AffectedData> affectedData = []; //
  StatesInIndia
      stateChosen; // It contains basic information about state , like capital and state code
  List<AffectedData> ofDateSelected =
      []; // To get The details inside Card , all cases till date
  List<StateNameOfDistricts> districtsAffected = [];
  List<DistrictZone> districtZone =
      []; // This stores green , red and orange zone data of each district

  StateNameOfDistricts
      findDistrictRelatedState; // Finds the state which was received from selectState Page which was received as stateChosen Object

  List<FlSpot> confirmedSpotxy = []; //X Y points for graph construction
  List<FlSpot> recoveredSpotxy = []; //X Y points for graph construction
  List<FlSpot> deceasedSpotxy = []; //X Y points for graph construction

  var date = DateTime.now();
  String
      showingDateOnScreen; // This date is used to find data in card , this has to be of a day before because present data gets updated a day after
  String
      dateForDistrictData; // This date is used to get district level data , this data is updated on daily basis
  String latestStateDataDated; // Stores date of latest updated data

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020, 03),
      lastDate: DateTime.now(),
    );
    setState(() {
      date = picked ?? date;
    });
    getDistrictDetailsFromDate(date.toString());
    getStateDetailsFromDate(date.toString(), 1);
  }

  getDistrictDetailsFromDate(String date) {
    var dateDistrict = DateTime.parse(date);
    var tempDate =
        dateDistrict.day < 10 ? '0${dateDistrict.day}' : '${dateDistrict.day}';
    var tempMonth = dateDistrict.month < 10
        ? '0${dateDistrict.month}'
        : '${dateDistrict.month}';
    setState(() {
      dateForDistrictData = '${dateDistrict.year}-${tempMonth}-${tempDate}';
    });
  }

  getStateDetailsFromDate(String date, int switcher) {
    print('Inside method getStateDetailsFromDate');

    ofDateSelected = [];
    if (switcher == 1) {
      var parseDate = DateTime.parse(date);
      String qdate = parseDate.day < 10
          ? ('0' + parseDate.day.toString())
          : parseDate.day.toString();

      String qyear = (parseDate.year ~/ 100).toString();
      List<String> qmonth = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      var formattedDate = '$qdate-${qmonth[parseDate.month - 1]}-$qyear';

      setState(() {
        for (var i in affectedData) {
          if (i.date == formattedDate) {
            ofDateSelected.add(i);
          }
        }
        showingDateOnScreen = formattedDate;
      });
      print('Date showing on screen $showingDateOnScreen');
      print('Inside method getStateDetailsFromDate task done');
      getPointsConfirmed(showingDateOnScreen); // To get line chart x y points

    } else {
      setState(() {
        for (var i in affectedData) {
          if (i.date == date) {
            ofDateSelected.add(i);
          }
        }
        showingDateOnScreen = date;
      });
      print('Date showing on screen $showingDateOnScreen');
      print('Inside method getStateDetailsFromDate task done');
      getPointsConfirmed(showingDateOnScreen);
    }
  }

  //Finds the State which was chosen from list and stores its district list
  findTheDistricts(StatesInIndia stateChosen) {
    var finder = stateChosen.name;
    if (finder == 'Dadra and Nagar Haveli' || finder == 'Daman and Diu') {
      //District data is only available for Dadra and Nagar Haveli and Daman and Diu
      finder = 'Dadra and Nagar Haveli and Daman and Diu';
    }
    for (var i in districtsAffected) {
      if (i.stateName == finder) {
        findDistrictRelatedState = i;
        break;
      }
    }
    print('District object from findTheDistricts $findDistrictRelatedState');

    //Remove comment to display districts of selected state
    // findDistrictRelatedState.districtList.forEach((element) {
    //   print(element.districtName);
    // });
  }

  //Get all points from AffectedData obj to create the graph
  getPointsConfirmed(String date) {
    print('Inside method getPointsConfirmed');

    recoveredSpotxy.clear();
    confirmedSpotxy.clear();
    deceasedSpotxy.clear();
    double conf = 0;
    double recov = 0;
    double dece = 0;
    for (var element in affectedData) {
      if (element.stateCode['date'] != date) {
        if (element.stateCode['status'] == 'Confirmed') {
          conf++;
          double y =
              double.parse(element.stateCode[stateChosen.code.toLowerCase()]);

          confirmedSpotxy.add(FlSpot(conf, y));
        }

        if (element.status == 'Recovered') {
          recov++;
          double y =
              double.parse(element.stateCode[stateChosen.code.toLowerCase()]);

          recoveredSpotxy.add(FlSpot(recov, y));
        }
        if (element.status == 'Deceased') {
          dece++;
          double y =
              double.parse(element.stateCode[stateChosen.code.toLowerCase()]);

          deceasedSpotxy.add(FlSpot(dece, y));
        }
      }
    }
    print('Retrieved x,y points successfully from getPointsConfirmed');
    print(confirmedSpotxy.length);

    //Uncomment to show graph points
    // print(recoveredSpotxy);
    // print(confirmedPoints);
    // print(deceasedPoints);
  }

  @override
  void initState() {
    print('initState of covid_status');

    index = widget.index;
    affectedData = widget.affectedData;
    districtZone = widget.districtZone;
    stateChosen = widget
        .stateChosen; // containes code which is used to get data from affectedData obj
    print('State received in covid_status ${stateChosen.name}');
    districtsAffected = widget.districtsAffected;
    latestStateDataDated = affectedData[affectedData.length - 1].date;
    getStateDetailsFromDate(latestStateDataDated, 2);

    getDistrictDetailsFromDate(DateTime.now().toString());
    findTheDistricts(stateChosen);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: Container(
                height: 100,
                margin: EdgeInsets.only(
                  top: 40,
                ),
                child: Column(
                  children: <Widget>[
                    Text(stateChosen.name),
                    Text(
                      'As Of $showingDateOnScreen',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 120,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () => _selectDate(context),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                threeCardWidget(),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                districtListWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  districtListWidget() {
    List<Widget> list = [];
    DistrictZone districtZoneColor;
    var zoneColor = Colors.white;
    Map<String, String> districtFix = {};
    districtFix['Foreign Evacuees'] = 'Not Available';
    districtFix['Unknown'] = 'Not Available';
    //Fix for Andhra Pradesh
    districtFix['Y.S.R.'] = 'Y.S.R. Kadapa';
    districtFix['Y.S.R Kadapa'] = 'Y.S.R. Kadapa';
    //Fix for Assam
    districtFix['South Salmara Mancachar'] = 'South Salmara Mankachar';
    //Fix for Bihar
    districtFix['Kaimur Bhabua'] = 'Kaimur';
    //Fix for Chhattisgarh
    districtFix['Gaurela Pendra Marwahi'] = 'Not Available';
    //fix for Gujarat
    districtFix['Ahmadabad'] = 'Ahmedabad';
    districtFix['Banas Kantha'] = 'Banaskantha';
    districtFix['Chota Udaipur'] = 'Chhota Udaipur';
    districtFix['Kachchh'] = 'Kutch';
    districtFix['Mahesana'] = 'Mehsana';
    districtFix['Panch Mahals'] = 'Panchmahal';
    districtFix['Sabar Kantha'] = 'Sabarkantha';
    //Fix for Haryana
    districtFix['Charki Dadri'] = 'Charkhi Dadri';
    districtFix['Italians*'] = 'Not Available';
    districtFix['Italians'] = 'Not Available';
    //Fix for J&K
    districtFix['Badgam'] = 'Budgam';
    districtFix['Bandipore'] = 'Bandipora';
    districtFix['Baramula'] = 'Baramulla';
    districtFix['Shupiyan'] = 'Shopiyan';
    //Fix for Jharkand
    districtFix['Kodarma'] = 'Koderma';
    //Fix for Karnataka
    districtFix['Bengaluru'] = 'Bengaluru Rural';
    //Fix for Madhya Pradesh
    districtFix['Other Region*'] = 'Not Available';
    districtFix['Other Region'] = 'Not Available';
    //Fis for Maharashtra
    districtFix['Ahmadnagar'] = 'Ahmednagar';
    districtFix['Bid'] = 'Beed';
    districtFix['Buldana'] = 'Buldhana';
    districtFix['Gondiya'] = 'Gondia';
    districtFix['Other States*'] = 'Not Available';
    districtFix['Other States'] = 'Not Available';
    //Fix for Odisha
    districtFix['Baleshwar'] = 'Not Available';
    districtFix['Jajapur'] = 'Jajpur';
    districtFix['Debagarh'] = 'Deogarh';
    //Fix for Punjab
    districtFix['Firozpur'] = 'Ferozepur';
    //Fix for Rajasthan
    districtFix['Dhaulpur'] = 'Dholpur';
    districtFix['Evacuees*'] = 'Not Available';
    districtFix['Evacuees'] = 'Not Available';
    districtFix['Chittaurgarh'] = 'Chittorgarh';
    districtFix['Others state'] = 'Not Available';
    districtFix['BSF Camp'] = 'Not Available';
    //Fix for sikkim
    districtFix['East Sikkim'] = 'East District';
    districtFix['North Sikkim'] = 'North District';
    districtFix['South Sikkim'] = 'South District';
    districtFix['West Sikkim'] = 'West District';
    //Fix for Tamil Nadu
    districtFix['Kanniyakumari'] = 'Kanyakumari';
    districtFix['The Nilgiris'] = 'Nilgiris';
    districtFix['Airport Quarantine'] = 'Not Available';
    districtFix['Railway Quarantine'] = 'Not Available';
    //Fix for Telangana
    districtFix['Jagitial'] = 'Jagtial';
    districtFix['Jangoan'] = 'Jangaon';
    districtFix['Jayashankar'] = 'Jayashankar Bhupalapally';
    districtFix['Kumuram Bheem Asifabad'] = 'Komaram Bheem';
    //Fix for Uttar Pradesh
    districtFix['Bara Banki'] = 'Barabanki';
    districtFix['Kheri'] = 'Not Available';
    districtFix['Mahrajganj'] = 'Maharajganj';
    //Fix for West Bengal
    districtFix['Medinipur East'] = 'Paschim Medinipur';
    for (var district in findDistrictRelatedState.districtList) {
      var districtTofind = district.districtName;
      if (districtFix.containsKey(district.districtName)) {
        districtTofind = districtFix[district.districtName];
      }
      if (districtTofind != 'Not Available') {
        for (var element in districtZone) {
          if (element.district == districtTofind) {
            districtZoneColor = element;
            break;
          }
        }

        if (districtZoneColor.zone == 'Green') {
          zoneColor = Colors.green;
        }
        if (districtZoneColor.zone == 'Red') {
          zoneColor = Colors.red;
        }
        if (districtZoneColor.zone == 'Orange') {
          zoneColor = Colors.orange;
        }
      } else {
        zoneColor = Colors.white;
      }

      for (var caseList in district.caseType) {
        if (caseList.date == dateForDistrictData)
          list.add(Column(
            children: <Widget>[
              Divider(
                thickness: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Color.fromARGB(255, 255, 220, 120),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: zoneColor,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          district.districtName,
                          style: TextStyle(fontSize: 10),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .5,
                        margin: EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  caseList.confirmed.toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  'C',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFF8748),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  caseList.active.toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  'A',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFF4848),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  caseList.recovered.toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  'R',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF36C12C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  caseList.deceased.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  'D',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFFF0000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
      }
    }
    return list;
  }

  threeCardWidget() {
    return ofDateSelected.length != 0
        ? Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(6.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    containerCardConfirmed('Confirmed',
                        '${ofDateSelected[0].stateCode[stateChosen.code.toLowerCase()]}'), // using stateChosen code
                    containerCardRecovered('Recovered',
                        '${ofDateSelected[1].stateCode[stateChosen.code.toLowerCase()]}'),
                    containerCardDeceased('Deceased',
                        '${ofDateSelected[2].stateCode[stateChosen.code.toLowerCase()]}'),
                  ],
                ),
              ),
            ],
          )
        : userWaitingMessage();
  }

  userWaitingMessage() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Text('Data Updated till [ $latestStateDataDated ]'),
          CircularProgressIndicator(),
          Text('Please wait loading data...'),
        ],
      ),
    );
  }

  containerCardConfirmed(String status, String numbers) {
    return Container(
      width: MediaQuery.of(context).size.width * .3,
      height: MediaQuery.of(context).size.height * .25,
      child: Card(
        elevation: 8.0,
        child: Column(
          children: <Widget>[
            Text(
              numbers,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFFF8748),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width * .3,
              child: LineChart(
                mainData(confirmedSpotxy),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xFFFF8748), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Color(0xFFFF8748)),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Confirmed",
                        style:
                            TextStyle(color: Color(0xFFFF8748), fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  containerCardRecovered(String status, String numbers) {
    return Container(
      width: MediaQuery.of(context).size.width * .3,
      height: MediaQuery.of(context).size.height * .25,
      child: Card(
        elevation: 8.0,
        child: Column(
          children: <Widget>[
            Text(
              numbers,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF36C12C),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width * .3,
              decoration: BoxDecoration(),
              child: LineChart(
                mainData(recoveredSpotxy),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xFF36C12C), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Color(0xFF36C12C)),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Recovered",
                        style:
                            TextStyle(color: Color(0xFF36C12C), fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  containerCardDeceased(String status, String numbers) {
    return Container(
      width: MediaQuery.of(context).size.width * .3,
      height: MediaQuery.of(context).size.height * .25,
      child: Card(
        elevation: 8.0,
        child: Column(
          children: <Widget>[
            Text(
              numbers,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFFF4848),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width * .3,
              decoration: BoxDecoration(),
              child: LineChart(
                mainData(deceasedSpotxy),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xFFFF4848), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Color(0xFFFF4848)),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 2.5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Deceased",
                        style:
                            TextStyle(color: Color(0xFFFF4848), fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData(xySpots) {
    return LineChartData(
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: xySpots != null
              ? xySpots
              : [
                  FlSpot(0, 3),
                  FlSpot(5, 4),
                  FlSpot(3, 7),
                  FlSpot(4, 1),
                  FlSpot(6, 22),
                  FlSpot(7, 9),
                ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
