class LoginResponseModel {
  final String token;
  final String userId;
  final String userName;
  final String fullName;

  LoginResponseModel({required this.token, required this.userId, required this.userName, required this.fullName});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final user = data['user'];
    return LoginResponseModel(
      token: data['token'],
      userId: user['_id'],
      userName: user['userName'],
      fullName: user['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'userName': userName,
      'fullName': fullName,
    };
  }
}
