class UserCreate {
  final String username;
  final String userPassword;
  final String userConfirmPassword;
  final String userEmail;
  final String userFullName;
  final String userPhoneNumber;

  UserCreate({
    required this.username,
    required this.userPassword,
    required this.userConfirmPassword,
    required this.userEmail,
    required this.userFullName,
    required this.userPhoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'UserPassword': userPassword,
      'UserConfirmPassword': userConfirmPassword,
      'UserEmail': userEmail,
      'UserFullName': userFullName,
      'UserPhoneNumber': userPhoneNumber,
    };
  }
}