class User {
  final int? id;
  final String userName;
  final int? isLogged;

  const User({this.id, required this.userName, required this.isLogged});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['userId'],
        userName: json['userName'],
        isLogged: json['isLogged'],
      );

  Map<String, dynamic> toJson() => {
        'userId': id,
        'userName': userName,
        'isLogged': isLogged,
      };
}
