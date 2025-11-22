import 'package:equatable/equatable.dart';

sealed class HException with EquatableMixin implements Exception {
  const HException(this.message, {this.statusCode, this.innerException});

  final String message;
  final int? statusCode;
  final Object? innerException;

  @override
  List<Object?> get props => [message, statusCode, innerException];
}

final class CreateUserException extends HException {
  const CreateUserException([
    super.message =
        'Failed to create user at this time. Please try again later',
  ]);
}

final class UnauthenticatedException extends HException {
  const UnauthenticatedException([
    super.message = 'Please sign in to continue',
  ]);
}
