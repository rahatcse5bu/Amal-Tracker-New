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
  final List<UserEntry> users;

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
    required this.users,
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
      users: (json['users'] as List<dynamic>? ?? [])
          .map((userJson) => UserEntry.fromJson(userJson))
          .toList(),
    );
  }
}

class UserEntry {
  final String id;
  final String user;
  final String day;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserEntry({
    required this.id,
    required this.user,
    required this.day,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserEntry.fromJson(Map<String, dynamic> json) {
    return UserEntry(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      day: json['day'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}
