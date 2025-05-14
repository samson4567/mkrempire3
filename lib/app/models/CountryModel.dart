import 'dart:convert';

class CountryModel {
  final Map<String, dynamic>? name;
  final List<String>? tld;
  final String? cca2;
  final String? ccn3;
  final String? cca3;
  final bool? independent;
  final String? status;
  final bool? unMember;
  final Map<String, dynamic>? currencies;
  final Map<String, dynamic>? idd;
  final List<String>? capital;
  final List<String>? altSpellings;
  final String? region;
  final Map<String, dynamic>? languages;
  final Map<String, dynamic>? translations;
  final List<double>? latlng;
  final bool? landlocked;
  final double? area;
  final Map<String, dynamic>? demonyms;
  final String? flag;
  final Map<String, dynamic>? maps;
  final int? population;
  final Map<String, dynamic>? car;
  final List<String>? timezones;
  final List<String>? continents;
  final Map<String, dynamic>? flags;
  final Map<String, dynamic>? coatOfArms;
  final String? startOfWeek;
  final Map<String, dynamic>? capitalInfo;

  CountryModel({
    this.name,
    this.tld,
    this.cca2,
    this.ccn3,
    this.cca3,
    this.independent,
    this.status,
    this.unMember,
    this.currencies,
    this.idd,
    this.capital,
    this.altSpellings,
    this.region,
    this.languages,
    this.translations,
    this.latlng,
    this.landlocked,
    this.area,
    this.demonyms,
    this.flag,
    this.maps,
    this.population,
    this.car,
    this.timezones,
    this.continents,
    this.flags,
    this.coatOfArms,
    this.startOfWeek,
    this.capitalInfo,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      tld: json['tld'] != null ? List<String>.from(json['tld']) : null,
      cca2: json['cca2'],
      ccn3: json['ccn3'],
      cca3: json['cca3'],
      independent: json['independent'],
      status: json['status'],
      unMember: json['unMember'],
      currencies: json['currencies'],
      idd: json['idd'],
      capital: json['capital'] != null ? List<String>.from(json['capital']) : null,
      altSpellings: json['altSpellings'] != null ? List<String>.from(json['altSpellings']) : null,
      region: json['region'],
      languages: json['languages'],
      translations: json['translations'],
      latlng: json['latlng'] != null ? List<double>.from(json['latlng'].map((x) => x.toDouble())) : null,
      landlocked: json['landlocked'],
      area: json['area']?.toDouble(),
      demonyms: json['demonyms'],
      flag: json['flag'],
      maps: json['maps'],
      population: json['population'],
      car: json['car'],
      timezones: json['timezones'] != null ? List<String>.from(json['timezones']) : null,
      continents: json['continents'] != null ? List<String>.from(json['continents']) : null,
      flags: json['flags'],
      coatOfArms: json['coatOfArms'],
      startOfWeek: json['startOfWeek'],
      capitalInfo: json['capitalInfo'],
    );
  }

  static List<CountryModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CountryModel.fromJson(json)).toList();
  }
}
