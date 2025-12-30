import 'cosmos_result.dart';

class CosmosResponse {
  final CosmosResult result;

  CosmosResponse({
    required this.result,
  });

  factory CosmosResponse.fromJson(Map<String, dynamic> json , bool success) {
    return CosmosResponse(
      result: CosmosResult.fromJson(json, success),
    );
  }
}