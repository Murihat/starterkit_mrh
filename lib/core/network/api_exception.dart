class ApiException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.errors});

  @override
  String toString() => message;
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.errors});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.errors});
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.errors});
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message, {super.errors});
}

class ServerException extends ApiException {
  ServerException(super.message, {super.errors});
}
