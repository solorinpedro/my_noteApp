class UserModel {
  String id;
  String username;
  String passwordVersion;
  String password;

  UserModel({
    required this.id,
    required this.username,
    required this.passwordVersion,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      passwordVersion: json['passwordVersion'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'passwordVersion': passwordVersion,
      'password': password,
    };
  }
}
