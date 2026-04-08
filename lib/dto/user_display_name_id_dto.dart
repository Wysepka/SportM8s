class UserDisplayNameIDDTO{
  final String displayName;
  final String id;

  UserDisplayNameIDDTO(this.displayName , this.id);

  factory UserDisplayNameIDDTO.fromJson(Map<String,dynamic> jsonMap){
    return UserDisplayNameIDDTO(
      jsonMap['displayName'] as String ?? "",
      jsonMap['id'] as String ?? ""
    );
  }
}