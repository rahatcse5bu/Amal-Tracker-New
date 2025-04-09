class AjkerHadithModel {
  final String id;
  final String bnText;
  final String enText;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  AjkerHadithModel({
    required this.id,
    required this.bnText,
    required this.enText,
    required this.createdAt,
    required this.updatedAt,
  });

  // **Factory method to create an object from JSON**
  factory AjkerHadithModel.fromJson(Map<String, dynamic> json) {
    return AjkerHadithModel(
      id: json['_id'] ?? '',
      bnText: json['text'] ?? 'কোনও হাদিস পাওয়া যায়নি',
      enText: json['enText'] ?? 'No Hadith available',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
