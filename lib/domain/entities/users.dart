class Users {
  int userID;
  String username;
  String userPassword;
  String userEmail;
  String userFullName;
  String userPhoneNumber;
  bool isLocked;

  Users({
    required this.userID,
    required this.username,
    required this.userPassword,
    required this.userEmail,
    required this.userFullName,
    required this.userPhoneNumber,
    required this.isLocked,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userID: json['UserID'],
      username: json['Username'],
      userPassword: json['UserPassword'],
      userEmail: json['UserEmail'],
      userFullName: json['UserFullName'],
      userPhoneNumber: json['UserPhoneNumber'],
      isLocked: json['IsLocked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'Username': username,
      'UserPassword': userPassword,
      'UserEmail': userEmail,
      'UserFullName': userFullName,
      'UserPhoneNumber': userPhoneNumber,
      'IsLocked': isLocked,
    };
  }
}