import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<String> suspectedFirstName = ['Name 1', 'Name 2', 'Name 3', 'Name 4'];
  List<String> suspectedState = ['State 1', 'State 2', 'State 3', 'State 4'];
  List<String> suspectedDist = ['Dist 1', 'Dist 2', 'Dist 3', 'Dist 4'];
  List<String> suspectedCity = ['City 1', 'City 2', 'City 3', 'City 4'];

  int totalReports = 4;

  @override
  void initState() {
    // fatchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: suspectedCity.length != totalReports
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 180.0,
                  flexibleSpace: FlexibleSpaceBar(
                      title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Reports : $totalReports',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
                ),
                SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return cardview(
                      suspectedState[index],
                      suspectedDist[index],
                      suspectedCity[index],
                    );
                  }, childCount: totalReports),
                  itemExtent: 200.0,
                )
              ],
            ),
    );
  }

  Widget cardview(String state, String dist, String city) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: new EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 6.0,
        ),
        elevation: 10.0,
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              setState(() {
                //SetData.psotUid=postUid;
              });
            },
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "State:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("$state", style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("District:", style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("$dist", style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("City:", style: TextStyle(fontSize: 18)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("$city", style: TextStyle(fontSize: 18)),
                        )
                      ],
                    )
                  ],
                ))));
  }
  // fatchData()async{
  //   try {
  //     await Firestore.instance.collection("Reports").orderBy("timeStamp",descending: true).getDocuments().then((
  //         onValue) {
  //       setState(() {
  //         totalReports = onValue.documents.length;
  //       });
  //       onValue.documents.forEach((f) {
  //         setState(() {
  //           suspectedState.add(f.data["suspectedState"]);
  //           suspectedDist.add(f.data['suspecteddDis']);
  //           suspectedCity.add(f.data[ 'suspectedCity']);

  //         });
  //       });
  //     });
  //   }
  //   catch(e){
  //     print(e);
  //   }

  // }

}
