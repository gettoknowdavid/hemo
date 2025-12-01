enum Gender { male, female }

const Map<Gender, String> $GenderMap = {.male: 'male', .female: 'female'};

extension GenderX on Gender {
  String get name => switch (this) {
    .male => 'Male',
    .female => 'Female',
  };
}
