class User {
  User({required this.login, required this.password});

  String login;
  String password;

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      password: json['password'],
    );
  }
}
