class DuaModel {
  final String id;
  final String title;
  final String bangla;
  final String arabic;

  DuaModel({
    required this.id,
    required this.title,
    required this.bangla,
    required this.arabic,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      bangla: json['bangla'] ?? '',
      arabic: json['arabic'] ?? '',
    );
  }
}
