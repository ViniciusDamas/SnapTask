class RegisterRequest {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': userName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class RegisterRsponse {
  final String token;

  RegisterRsponse({required this.token});

  factory RegisterRsponse.fromJson(Map<String, dynamic> json) {
    return RegisterRsponse(token: json['token'] as String);
  }
}
