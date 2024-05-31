class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // This method creates a new User object with the provided password hashed
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password != null ? hashPassword(password) : this.password,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, password: $password}';
  }
}

String hashPassword(String password) {
  // Implement password hashing logic here
  return 'hashed_$password'; // Placeholder implementation, replace with actual password hashing logic
}
