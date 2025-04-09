class KoroniyoModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  KoroniyoModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create object from JSON
  factory KoroniyoModel.fromJson(Map<String, dynamic> json) {
    return KoroniyoModel(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }
}
