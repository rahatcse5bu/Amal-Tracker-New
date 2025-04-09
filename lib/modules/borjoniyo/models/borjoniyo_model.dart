class BorjoniyoModel {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  BorjoniyoModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create object from JSON
  factory BorjoniyoModel.fromJson(Map<String, dynamic> json) {
    return BorjoniyoModel(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }
}
