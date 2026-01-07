class ApiError{
 final int errorCode;
 final String errorMessage;
 final int? correlationID;
 final Map<String, String>? fieldErrors;

 ApiError({required this.errorCode, required this.errorMessage , this.correlationID , this.fieldErrors});

 factory ApiError.fromJson(Map<String,dynamic> json){
   return ApiError(
       errorCode: json['errorCode'],
       errorMessage: json['errorMessage'],
       correlationID: json['correlationID'],
       fieldErrors: (json['fieldErrors'] as Map?)?.map(
           (k,v) => MapEntry(k.toString(), v.toString()),
       ));
 }
}