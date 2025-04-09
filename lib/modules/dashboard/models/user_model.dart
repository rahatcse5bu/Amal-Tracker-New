class UserModel {
  final String? userName;
  final String? fullName;
  final int totalPoints;

  UserModel({ this.userName,  this.fullName, required this.totalPoints});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json['user']['userName'] ?? '',
      fullName: json['user']['fullName'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
    );
  }
}
