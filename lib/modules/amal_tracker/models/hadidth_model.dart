class HadithModel {
  final String text;

  HadithModel({required this.text});

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      text: json['text'] ?? '',
    );
  }
}
