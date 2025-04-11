class TrackingOption {
  final String id;
  final String title;
  final String description;
  final int point;
  final int index;
  final int milestone;
  final int totalCount;
  final bool isInMosque;
  final bool isKhushuKhuzu;
  final bool isQadha;
  final bool isRegularOrder;
  final bool isInJamayat;
  final int khushuLevel; // Add this for 1-5 rating
  final bool isCountable;
  final bool isSalatTracking;
  final bool isHayez;
  final bool isQasr;
  final List<UserEntry> users;
  final String enTitle;
  final String enDescription;
  final String arTitle;
  final String arabic;
  final String arDescription;
  final String descriptionEn;

  TrackingOption({
    required this.id,
    required this.title,
    required this.description,
    required this.point,
    required this.index,
    required this.milestone,
    required this.totalCount,
    required this.isInMosque,
    required this.isKhushuKhuzu,
    required this.isQadha,
    required this.isRegularOrder,
    required this.isInJamayat,
    this.khushuLevel = 2,
    this.isCountable = false,
    this.isSalatTracking = false,
    this.isHayez = false,
    this.isQasr = false,
    required this.users,
    this.enTitle = '',
    this.enDescription = '',
    this.arTitle = '',
    this.arabic = '',
    this.arDescription = '',
    this.descriptionEn = '',
  });

  factory TrackingOption.fromJson(Map<String, dynamic> json) {
    return TrackingOption(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      point: json['point'] ?? 0,
      index: json['index'] ?? 0,
      milestone: json['milestone'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      isInMosque: json['isInMosque'] ?? false,
      isKhushuKhuzu: json['isKhushuKhuzu'] ?? false,
      isQadha: json['isQadha'] ?? false,
      isRegularOrder: json['isRegularOrder'] ?? false,
      isInJamayat: json['isInJamayat'] ?? false,
      khushuLevel: json['khushuLevel'] ?? 0,
      isCountable: json['isCountable'] ?? false,
      isSalatTracking: json['isSalatTracking'] ?? false,
      isHayez: json['isHayez'] ?? false,
      isQasr: json['isQasr'] ?? false,
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => UserEntry.fromJson(userJson))
          .toList(),
      enTitle: json['enTitle'] ?? '',
      enDescription: json['enDescription'] ?? '',
      arTitle: json['arTitle'] ?? '',
      arabic: json['arabic'] ?? '',
      arDescription: json['arDescription'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
    );
  }
}

class UserEntry {
  final String id;
  final String user;
  final String day;
  final bool isInMosque;
  final bool isKhushuKhuzu;
  final bool isQadha;
  final bool isRegularOrder;
  final int? khushuLevel;
  final bool isInJamayat;
  final bool isSalatTracking;
  final bool isHayez;
  final bool isQasr;
  final int totalCount;
  final int totalPoint;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserEntry({
    required this.id,
    required this.user,
    required this.day,
    required this.isInMosque,
    required this.isKhushuKhuzu,
    required this.isQadha,
    required this.isRegularOrder,
    this.khushuLevel,
    required this.isInJamayat,
    required this.isSalatTracking,
    required this.isHayez,
    required this.isQasr,
    required this.totalCount,
    required this.totalPoint,
    this.createdAt,
    this.updatedAt,
  });

  factory UserEntry.fromJson(Map<String, dynamic> json) {
    return UserEntry(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      day: json['day'] ?? '',
      isInMosque: json['isInMosque'] ?? false,
      isKhushuKhuzu: json['isKhushuKhuzu'] ?? false,
      isQadha: json['isQadha'] ?? false,
      isRegularOrder: json['isRegularOrder'] ?? false,
      khushuLevel: json['khushuLevel'],
      isInJamayat: json['isInJamayat'] ?? false,
      isSalatTracking: json['isSalatTracking'] ?? false,
      isHayez: json['isHayez'] ?? false,
      isQasr: json['isQasr'] ?? false,
      totalCount: json['totalCount'] ?? 0,
      totalPoint: json['totalPoint'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
