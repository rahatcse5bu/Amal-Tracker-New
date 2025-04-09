// lib/app/translations/translation_keys.dart
class TranslationKeys {
  // Define all translation keys as static constants
  static const String hello = 'hello';
  static const String welcomeMessage = 'welcome_message';
  static const String changeLanguage = 'change_language';
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String fastingTime = 'fasting_time';
  static const String iftarTime = 'iftar_time';
  static const String sehriTime = 'sehri_time';
  static const String prayerTimes = 'prayer_times';
  static const String trackPrayers = 'track_prayers';
  static const String trackFasting = 'track_fasting';
  static const String trackRamadan = 'trackRamadan';

  static const String selectedVerses = 'selected_verses'; // New key
  static const String selectedHadith = 'selected_hadith';
  static const String salafQuotes = 'salaf_quotes';

  static const String ramadan = 'ramadan';
  static const String planRamadan = 'planRamadan';
  static const String leaderBoard = 'leaderBoard';
  static const String rank = 'rank';
  static const String pointsDisclaimer = 'points_disclaimer';

  static const String home = 'home';
  static const String duas = 'duas';
  static const String more = 'more';
  static const String koroniyo = 'koroniyo';
  static const String borjoniyo = 'borjoniyo';
  static const String ramadaneBorjoniyo = 'ramadaneBorjoniyo';
  static const String ramadaneKoroniyo = 'ramadaneKoroniyo';
  static const String today = 'today';
  static const String todayHadidth = 'todayHadidth';
  static const String todayVerse = 'todayVerse';
  static const String todayPoint = 'todayPoint';

  //trackings
  static const nightTracking = 'nightTracking';
  static const fajrTracking = 'fajrTracking';
  static const zuhrTracking = 'zuhrTracking';
  static const asrTracking = 'asrTracking';
  static const afternoonTracking = 'afternoonTracking';
  static const qadrTracking = 'qadrTracking';
  static const generalTracking = 'generalTracking';
  static const eveningTracking = 'eveningTracking';
}

// lib/app/translations/bn_BD/bn_bd_translations.dart
final Map<String, String> bnBd = {
  TranslationKeys.hello: 'স্বাগতম',
  TranslationKeys.welcomeMessage: 'রমাদান ট্র্যাকারে স্বাগতম',
  TranslationKeys.changeLanguage: 'ভাষা পরিবর্তন করুন',
  TranslationKeys.settings: 'সেটিংস',
  TranslationKeys.profile: 'প্রোফাইল',
  TranslationKeys.fastingTime: 'রোজার সময়',
  TranslationKeys.iftarTime: 'ইফতারের সময়',
  TranslationKeys.sehriTime: 'সেহরির সময়',
  TranslationKeys.prayerTimes: 'নামাজের সময়',
  TranslationKeys.trackPrayers: 'নামাজ ট্র্যাক করুন',
  TranslationKeys.trackFasting: 'রোজা ট্র্যাক করুন',
  TranslationKeys.trackRamadan: 'রমাদ্বন ট্র্যাক করুন',
  TranslationKeys.selectedVerses: 'নির্বাচিত আয়াত',
  TranslationKeys.selectedHadith: 'নির্বাচিত হাদিস',
  TranslationKeys.salafQuotes: 'সালাফদের বক্তব্য',
  TranslationKeys.ramadan: 'রমাদ্বন',
  TranslationKeys.planRamadan: 'রমাদ্বন প্লান করুন',
  TranslationKeys.leaderBoard: 'লিডারবোর্ড',
  TranslationKeys.rank: 'র‍্যাংক',
  TranslationKeys.pointsDisclaimer:
      'কোনো আমাল এই পয়েন্ট দিয়ে সাব্যস্ত করার অধিকার কারোর-ই নেই।জাস্ট নিজের আমাল জাজ করার জন্যই এটি দেওয়া। নিয়ত করবেন সওয়াবের, আল্লাহ্‌ প্রতিদান দিবেন ইনশাআল্লাহ্‌!(লিডারবোর্ড দেখতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)',

  TranslationKeys.home: 'হোম',
  TranslationKeys.duas: "দু'আ সমুহ",
  TranslationKeys.more: 'আরও',
  TranslationKeys.koroniyo: 'করণীয়',
  TranslationKeys.borjoniyo: 'বর্জনীয়',
  TranslationKeys.ramadaneBorjoniyo: 'রমাদ্বনে বর্জনীয়',
  TranslationKeys.ramadaneKoroniyo: 'রমাদ্বনে করণীয়',
  TranslationKeys.today: 'আজ',
  TranslationKeys.todayHadidth: 'আজকের হাদিস',
  TranslationKeys.todayVerse: 'আজকের আয়াত',
  TranslationKeys.todayPoint: 'আজকের পয়েন্ট',
  //trackings
  TranslationKeys.nightTracking: 'রাত ট্র্যাকিং',
  TranslationKeys.fajrTracking: 'ফজর ট্র্যাকিং',
  TranslationKeys.zuhrTracking: 'যোহর ট্র্যাকিং',
  TranslationKeys.asrTracking: 'আসর ট্র্যাকিং',
  TranslationKeys.afternoonTracking: 'বিকেল ট্র্যাকিং',
  TranslationKeys.qadrTracking: 'ক্বদর ট্র্যাকিং',
  TranslationKeys.generalTracking: 'অত্যন্ত প্রয়োজনীয়',
  TranslationKeys.eveningTracking: 'সন্ধ্যা ট্র্যাকিং',
};

// lib/app/translations/en_US/en_us_translations.dart
final Map<String, String> enUs = {
  TranslationKeys.hello: 'Hello',
  TranslationKeys.welcomeMessage: 'Welcome to Ramadan Tracker',
  TranslationKeys.changeLanguage: 'Change Language',
  TranslationKeys.settings: 'Settings',
  TranslationKeys.profile: 'Profile',
  TranslationKeys.fastingTime: 'Fasting Time',
  TranslationKeys.iftarTime: 'Iftar Time',
  TranslationKeys.sehriTime: 'Sehri Time',
  TranslationKeys.prayerTimes: 'Prayer Times',
  TranslationKeys.trackPrayers: 'Track Prayers',
  TranslationKeys.trackFasting: 'Track Fasting',
  TranslationKeys.selectedVerses: 'Selected Verses',
  TranslationKeys.selectedHadith: 'Selected Hadith',
  TranslationKeys.salafQuotes: 'Salaf Quotes',
  TranslationKeys.ramadan: 'Ramadan',
  TranslationKeys.planRamadan: 'Plan Ramadan',
  TranslationKeys.trackRamadan: 'Track Ramadan',
  TranslationKeys.leaderBoard: 'Leaderboard',
  TranslationKeys.rank: 'Rank',
  TranslationKeys.pointsDisclaimer:
      'No one has the right to validate deeds through these points. This is only for self-assessment of your deeds. Maintain intention for reward, Allah will surely reward you InshaAllah! (Click the arrow button on the right side to view leaderboard)',

  TranslationKeys.home: 'Home',
  TranslationKeys.duas: 'List of Dua',
  TranslationKeys.more: 'More',
  TranslationKeys.koroniyo: 'Koroniyo',
  TranslationKeys.borjoniyo: 'Borjoniyo',
  TranslationKeys.ramadaneBorjoniyo: 'Restricted For Ramadan',
  TranslationKeys.ramadaneKoroniyo: 'Admirable For Ramadan',
  TranslationKeys.today: 'Today',
  TranslationKeys.todayHadidth: "Today's Hadidth",
  TranslationKeys.todayVerse: "Today's Verse",
  TranslationKeys.todayPoint: "Today's Point",
  //trackings
  TranslationKeys.nightTracking: 'Night Tracking',
  TranslationKeys.fajrTracking: 'Fajr Tracking',
  TranslationKeys.zuhrTracking: 'Zuhr Tracking',
  TranslationKeys.asrTracking: 'Asr Tracking',
  TranslationKeys.afternoonTracking: 'Afternoon Tracking',
  TranslationKeys.qadrTracking: 'Qadr Tracking',
  TranslationKeys.generalTracking: 'General Tracking',
  TranslationKeys.eveningTracking: 'Evening Tracking',
};
