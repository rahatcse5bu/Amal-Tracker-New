class AyatModel {
  final String id;
  final String bnText;
  final String enText;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  AyatModel({
    required this.id,
    required this.bnText,
    required this.enText,
    required this.createdAt,
    required this.updatedAt,
  });

  // **Factory method to create an object from JSON**
  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      id: json['_id'] ?? '',
      bnText: json['text'] ?? 'কোনও Ayat পাওয়া যায়নি',
      enText: json['enText'] ?? 'No Ayat available',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
