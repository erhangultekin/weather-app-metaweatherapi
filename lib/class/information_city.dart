class locations {
  int? distance;
  String? title;
  String? locationType;
  int? woeid;
  String? lattLong;

  locations.fromJsonMap(Map<String, dynamic> map) {
    distance = map['distance'];
    title = map['title'];
    locationType = map['location_type'];
    woeid = map['woeid'];
    lattLong = map['latt_long'];
  }
}
