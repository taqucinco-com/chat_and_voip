import 'package:myflutterapp/framework/exception/iterable_exception.dart';

class ValidationException implements Exception {
  final Object? message;
  ValidationException([this.message]);
}

typedef ValidationsException = IterableException<ValidationException>;
