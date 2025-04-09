class SalafQuoteModel {
  final String id;
  final String bnText;
  final String enText;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  SalafQuoteModel({
    required this.id,
    required this.bnText,
    required this.enText,
    required this.createdAt,
    required this.updatedAt,
  });

  // **Factory method to create an object from JSON**
  factory SalafQuoteModel.fromJson(Map<String, dynamic> json) {
    return SalafQuoteModel(
      id: json['_id'] ?? '',
      bnText: json['text'] ?? 'কোনও তথ্য পাওয়া যায়নি',
      enText: json['enText'] ?? 'No quote available',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // **Convert object to JSON (useful for local storage)**
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'text': bnText,
      'enText': enText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
