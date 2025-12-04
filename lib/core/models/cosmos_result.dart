class CosmosResult {
  final List<dynamic>? headers;
  final Map<String, dynamic>? resource;
  final int statusCode;
  final Map<String, dynamic>? diagnostics;
  final double requestCharge;
  final String activityId;
  final String eTag;

  CosmosResult({
    required this.headers,
    required this.resource,
    required this.statusCode,
    required this.diagnostics,
    required this.requestCharge,
    required this.activityId,
    required this.eTag,
  });

  factory CosmosResult.fromJson(Map<String, dynamic> json) {
    return CosmosResult(
      headers: json["headers"],
      resource: json["resource"],
      statusCode: json["statusCode"],
      diagnostics: json["diagnostics"],
      requestCharge: (json["requestCharge"] as num).toDouble(),
      activityId: json["activityId"],
      eTag: json["eTag"],
    );
  }
}