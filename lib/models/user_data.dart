class User {
  final String email;
  final String password;
  final String name;
  final String licenseKey;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.licenseKey
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      licenseKey: json['licenseKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'licenseKey': licenseKey,
    };
  }
}