import 'package:equatable/equatable.dart';

sealed class HException with EquatableMixin implements Exception {
  const HException(this.message, {this.statusCode, this.innerException});

  final String message;
  final int? statusCode;
  final Object? innerException;

  @override
  List<Object?> get props => [message, statusCode, innerException];
}
