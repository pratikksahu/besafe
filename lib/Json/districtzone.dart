class DistrictZone {
  String district;
  String districtcode;
  String lastupdated;
  String source;
  String state;
  String statecode;
  String zone;

  DistrictZone({
    this.district,
    this.districtcode,
    this.lastupdated,
    this.source,
    this.state,
    this.statecode,
    this.zone,
  });

  factory DistrictZone.fromJson(Map<String, dynamic> parsedJson) {
    return DistrictZone(
      district: parsedJson['district'],
      districtcode: parsedJson['districtcode'],
      lastupdated: parsedJson['lastupdated'],
      source: parsedJson['source'],
      state: parsedJson['state'],
      statecode: parsedJson['statecode'],
      zone: parsedJson['zone'],
    );
  }
}
