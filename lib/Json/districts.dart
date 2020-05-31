//Dadra and Nagar Haveli
//Daman and Diu

//Dadra and Nagar Haveli
//Dadra and Nagar Haveli and Daman and Diu

class StateNameOfDistricts {
  String stateName;
  List<DistrictsList> districtList;
  StateNameOfDistricts({
    this.stateName,
    this.districtList,
  });

  factory StateNameOfDistricts.fromJson(
      String stateName, Map<String, dynamic> parsedJson) {
    return StateNameOfDistricts(
      stateName: stateName,
      districtList: parseDistrictList(parsedJson),
    );
  }

  static parseDistrictList(parsedJson) {
    List<DistrictsList> district = new List<DistrictsList>();
    parsedJson.forEach((districtName, cases) {
      district.add(DistrictsList.fromJson(districtName, cases));
    });
    return district;
  }
}

class DistrictsList {
  String districtName;
  List<CaseType> caseType;
  DistrictsList({
    this.districtName,
    this.caseType,
  });

  factory DistrictsList.fromJson(String district, parsedJson) {
    return DistrictsList(
      districtName: district,
      caseType: parseCaseType(parsedJson),
    );
  }

  static List<CaseType> parseCaseType(parsedJson) {
    List<CaseType> retur = new List<CaseType>();
    parsedJson.map<CaseType>((e) {
      CaseType temp = CaseType.fromJson(e);
      retur.add(temp);
    }).toList();
    return retur;
  }
}

class CaseType {
  String notes;
  int active;
  int confirmed;
  int deceased;
  int recovered;
  String date;

  CaseType({
    this.notes,
    this.active,
    this.confirmed,
    this.deceased,
    this.recovered,
    this.date,
  });

  factory CaseType.fromJson(Map<String, dynamic> parsedJson) {
    return CaseType(
      notes: parsedJson['notes'],
      active: parsedJson['active'],
      confirmed: parsedJson['confirmed'],
      deceased: parsedJson['deceased'],
      recovered: parsedJson['recovered'],
      date: parsedJson['date'],
    );
  }
}
