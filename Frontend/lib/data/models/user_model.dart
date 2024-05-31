// models/user_model.dart
class User {
 final String id;
 final String name;
 final String email;
 final String password;

  User({
    this.id='',
    this.name='',
    this.email='',
    this.password='',
  });

  User copyWith({String? id, String? name, String? email, String? password}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
     password: password ?? this.password,
    );
  }
}

