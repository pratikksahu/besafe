class StatesInIndia {
  String id;
  String type;
  String capital;
  String code;
  String name;
  List<Districts> districts;
  StatesInIndia({
    this.id,
    this.type,
    this.capital,
    this.code,
    this.name,
    this.districts,
  });
  factory StatesInIndia.fromJson(Map<String, dynamic> parsedJson) {
    return StatesInIndia(
      id: parsedJson['id'],
      type: parsedJson['type'],
      capital: parsedJson['capital'],
      code: parsedJson['code'],
      name: parsedJson['name'],
      districts : parseDistricts(parsedJson),
    );
  }

  static List<Districts> parseDistricts(parsedJson){
    return parsedJson['districts'].map<Districts>((obj) => Districts.fromJson(obj)).toList();
  }
}

class Districts {
  String id;
  String name;
  Districts({
    this.id,
    this.name,
  });

  factory Districts.fromJson(Map<String, dynamic> parsedJson) {
    return Districts(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
