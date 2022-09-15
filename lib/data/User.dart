class User {
  late String elderlyId;
  late final String cgEmail;
  late final String elderlyName;
  late final String phoneNumber;
  late String resText = '';

  User({
    required this.elderlyId,
  });

  void setResText(String text){
    resText = text;
  }

  factory User.fromJson(Map<String, dynamic> userMap)
  {
    return User(
      elderlyId: userMap['elderly_id'],
    );
  }
}
