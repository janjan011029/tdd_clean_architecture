// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class APIException extends Equatable {
  const APIException({
    required this.message,
    required this.statusCode
  });

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}
