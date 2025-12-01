import 'package:equatable/equatable.dart';

final class City with EquatableMixin {
  const City({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateCode,
    required this.countryId,
    required this.countryCode,
    this.latitude,
    this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      stateId: json['state_id'] as int,
      stateCode: json['state_code'] as String,
      countryId: json['country_id'] as int,
      countryCode: json['country_code'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  final int id;
  final String name;
  final int stateId;
  final String stateCode;
  final int countryId;
  final String countryCode;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'state_id': stateId,
    'state_code': stateCode,
    'country_id': countryId,
    'country_code': countryCode,
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    stateId,
    stateCode,
    countryId,
    countryCode,
    latitude,
    longitude,
  ];
}
