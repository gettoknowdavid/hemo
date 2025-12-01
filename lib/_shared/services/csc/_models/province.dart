import 'package:equatable/equatable.dart';

final class Province with EquatableMixin {
  const Province({
    required this.id,
    required this.name,
    required this.countryId,
    required this.countryCode,
    this.latitude,
    this.longitude,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'] as int,
      name: json['name'] as String,
      countryId: json['country_id'] as int,
      countryCode: json['country_code'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  final int id;
  final String name;
  final int countryId;
  final String countryCode;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country_id': countryId,
    'country_code': countryCode,
    'latitude': latitude,
    'longitude': longitude,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    countryId,
    countryCode,
    latitude,
    longitude,
  ];
}
