class PrayerTimes {
  final DateTime date;
  final Prayer fajr;
  final Prayer sunrise;
  final Prayer dhuhr;
  final Prayer asr;
  final Prayer maghrib;
  final Prayer isha;
  final SpecialTiming sehri;
  final SpecialTiming iftar;
  final SpecialTiming ishrak;
  final SpecialTiming tahajjud;
  final List<ForbiddenPeriod> forbiddenPeriods;

  PrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sehri,
    required this.iftar,
    required this.ishrak,
    required this.tahajjud,
    required this.forbiddenPeriods,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      date: DateTime.parse(json['date']),
      fajr: Prayer.fromJson(json['fajr']),
      sunrise: Prayer.fromJson(json['sunrise']),
      dhuhr: Prayer.fromJson(json['dhuhr']),
      asr: Prayer.fromJson(json['asr']),
      maghrib: Prayer.fromJson(json['maghrib']),
      isha: Prayer.fromJson(json['isha']),
      sehri: SpecialTiming.fromJson(json['sehri']),
      iftar: SpecialTiming.fromJson(json['iftar']),
      ishrak: SpecialTiming.fromJson(json['ishrak']),
      tahajjud: SpecialTiming.fromJson(json['tahajjud']),
      forbiddenPeriods: (json['forbidden_periods'] as List)
          .map((e) => ForbiddenPeriod.fromJson(e))
          .toList(),
    );
  }

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'fajr': {
        'starts': fajr.starts,
        'ends': fajr.ends,
        'iqamah': fajr.iqamah,
      },
      // ...similar for other prayers...
    };
  }

  // Add data validation
  bool isValid() {
    return fajr.starts.isNotEmpty && 
           sunrise.starts.isNotEmpty && 
           dhuhr.starts.isNotEmpty &&
           asr.starts.isNotEmpty &&
           maghrib.starts.isNotEmpty &&
           isha.starts.isNotEmpty;
  }

  // Add toString method for debugging
  @override
  String toString() {
    return 'PrayerTimes(fajr: ${fajr.starts}, dhuhr: ${dhuhr.starts})';
  }
}

class Prayer {
  final String starts;
  final String ends;
  final String iqamah;

  Prayer({
    required this.starts,
    required this.ends,
    required this.iqamah,
  });

  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      starts: json['starts'] ?? '',
      ends: json['ends'] ?? '',
      iqamah: json['iqamah'] ?? '',
    );
  }
}

class SpecialTiming {
  final String starts;
  final String ends;

  SpecialTiming({
    required this.starts,
    required this.ends,
  });

  factory SpecialTiming.fromJson(Map<String, dynamic> json) {
    return SpecialTiming(
      starts: json['starts'] ?? '',
      ends: json['ends'] ?? '',
    );
  }
}

class ForbiddenPeriod {
  final String name;
  final String starts;
  final String ends;
  final String reason;

  ForbiddenPeriod({
    required this.name,
    required this.starts,
    required this.ends,
    required this.reason,
  });

  factory ForbiddenPeriod.fromJson(Map<String, dynamic> json) {
    return ForbiddenPeriod(
      name: json['name'] ?? '',
      starts: json['starts'] ?? '',
      ends: json['ends'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
