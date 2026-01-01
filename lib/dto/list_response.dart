class ListResponse<T> {
  final List<T> items;
  final String? reason;

  ListResponse({ required this.items, this.reason });

  /*
  factory ListResponse.fromJson(Map<String, dynamic> json , T Function(dynamic json) fromJsonT){
    return ListResponse(
        items: (json["items"] as List<dynamic> ?? []).map(fromJsonT).toList(),
        reason: json["response"] as String,
    );
  }

   */

  factory ListResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    final rawItems = json['items'] as List<dynamic>?; // nullable
    return ListResponse<T>(
      items: (rawItems ?? const []).map((e) => fromJsonT(e)).toList(),
      reason: json['response'] as String?, // keep it nullable-safe
    );
  }
}