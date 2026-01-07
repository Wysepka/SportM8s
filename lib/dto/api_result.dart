import 'package:sportm8s/dto/api_error.dart';

sealed class ApiResult<T>{
  const ApiResult(this.success , this.statusCode);
  final bool success;
  final int statusCode;
}

class ErrorResult<T> extends ApiResult<T>{
  final ApiError error;
  final String? correlationID;
  const ErrorResult({required this.error , required int statusCode ,this.correlationID }) : super(false , statusCode);
}

class OkResult<T> extends ApiResult<T>{
  final T data;
  final String? correlationID;
  const OkResult({required this.data, required int statusCode , this.correlationID}) : super(true , statusCode);
}

class OkResultPaginated<T> extends ApiResult<T>{
  final T data;
  final String continuationToken;
  final String? correlationID;
  const OkResultPaginated({required this.data, required this.continuationToken, required int statusCode , this.correlationID}) : super(true , statusCode);
}