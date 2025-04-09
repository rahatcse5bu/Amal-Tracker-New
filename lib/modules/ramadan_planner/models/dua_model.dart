class DuaModel {
  final String title;
  final String arabic;
  final String bangla;

  DuaModel({required this.title, required this.arabic, required this.bangla});

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      title: json['title'] ?? '',
      arabic: json['arabic'] ?? '',
      bangla: json['bangla'] ?? '',
    );
  }
}
