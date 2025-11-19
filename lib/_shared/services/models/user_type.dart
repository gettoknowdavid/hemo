enum UserType { donor, recipient, admin }

extension UserTypeX on UserType {
  bool get isDonor => this == .donor;

  bool get isRecipient => this == .recipient;

  bool get isAdmin => this == .admin;
}

const Map<UserType, String> $UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.donor: 'donor',
  UserType.recipient: 'recipient',
};
