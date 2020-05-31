class AcrossIndia {
  String dailyconfirmed;
  String dailydeceased;
  String dailyrecovered;
  String date;
  String totalconfirmed;
  String totaldeceased;
  String totalrecovered;

  AcrossIndia({
    this.dailyconfirmed,
    this.dailydeceased,
    this.dailyrecovered,
    this.date,
    this.totalconfirmed,
    this.totaldeceased,
    this.totalrecovered,
  });

  factory AcrossIndia.fromJson(Map<String, dynamic> parsedJson) {
    return AcrossIndia(
      dailyconfirmed: parsedJson['dailyconfirmed'],
      dailydeceased: parsedJson['dailydeceased'],
      dailyrecovered: parsedJson['dailyrecovered'],
      date: parsedJson['date'],
      totalconfirmed: parsedJson['totalconfirmed'],
      totaldeceased: parsedJson['totaldeceased'],
      totalrecovered: parsedJson['totalrecovered'],
    );
  }
}
