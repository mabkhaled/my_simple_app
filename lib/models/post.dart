class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  User? user;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    userId: json['userId'],
    title: json['title'],
    body: json['body'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
  };

  // Add this copyWith method
  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    User? user,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      user: user ?? this.user,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}