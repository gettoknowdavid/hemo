enum BloodGroup {
  aPos,
  aNeg,
  bPos,
  bNeg,
  oPos,
  oNeg,
  abPos,
  abNeg,
  unknown
  ;

  static List<BloodGroup> uiValues = [
    .aPos,
    .aNeg,
    .bPos,
    .bNeg,
    .oPos,
    .oNeg,
    .abPos,
    .abNeg,
  ];
}

extension BloodGroupX on BloodGroup {
  bool get isAPos => this == .aPos;

  bool get isANeg => this == .aNeg;

  bool get isBPos => this == .bPos;

  bool get isBNeg => this == .bNeg;

  bool get isOPos => this == .oPos;

  bool get isONeg => this == .oNeg;

  bool get isABPos => this == .abPos;

  bool get isABNeg => this == .abNeg;

  bool get isUnknown => this == .unknown;

  String get name => switch (this) {
    .aPos => 'A+',
    .aNeg => 'A-',
    .bPos => 'B+',
    .bNeg => 'B-',
    .oPos => 'O+',
    .oNeg => 'O-',
    .abPos => 'AB+',
    .abNeg => 'AB-',
    .unknown => 'UNKNOWN',
  };
}

const Map<BloodGroup, String> $BloodGroupMap = {
  .aPos: 'A+',
  .aNeg: 'A-',
  .bPos: 'B+',
  .bNeg: 'B-',
  .oPos: 'O+',
  .oNeg: 'O-',
  .abPos: 'AB+',
  .abNeg: 'AB-',
  .unknown: 'UNKNOWN',
};
