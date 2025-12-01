import 'package:equatable/equatable.dart';

final class Country with EquatableMixin {
  const Country({
    required this.id,
    required this.name,
    required this.iso2,
    required this.iso3,
    this.latitude,
    this.longitude,
    this.emoji,
    this.emojiU,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
      iso2: json['iso2'] as String,
      iso3: json['iso3'] as String,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      emoji: json['emoji'] as String?,
      emojiU: json['emojiU'] as String?,
    );
  }

  final int id;
  final String name;
  final String iso3;
  final String iso2;
  final String? latitude;
  final String? longitude;
  final String? emoji;
  final String? emojiU;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iso2': iso2,
    'iso3': iso3,
    'latitude': latitude,
    'longitude': longitude,
    'emoji': emoji,
    'emojiU': emojiU,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    iso2,
    iso3,
    latitude,
    longitude,
    emoji,
    emojiU,
  ];
}
