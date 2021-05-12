class Weather {
  final String? id;
  final String? weatherStateName;
  final String? weatherStateAbbr;
  final String? windDirectionCompass;
  final String? created;
  final String? applicableDate;
  final String? minTemp;
  final String? maxTemp;
  final String? theTemp;
  final String? windSpeed;
  final String? windDirection;
  final String? airPressure;
  final String? humidity;
  final String? visibility;
  final String? predictability;

  Weather(
      this.id,
      this.weatherStateName,
      this.weatherStateAbbr,
      this.windDirectionCompass,
      this.created,
      this.applicableDate,
      this.minTemp,
      this.maxTemp,
      this.theTemp,
      this.windSpeed,
      this.windDirection,
      this.airPressure,
      this.humidity,
      this.visibility,
      this.predictability);
}
