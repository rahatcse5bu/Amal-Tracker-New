import 'package:get/get.dart';

class Dhikr {
  final String id;
  final String name;
  final String arabicText;
  final String bengaliText;
  final String meaning;
  final int targetCount;
  var count = 0.obs; // Current count in cycle (0 to targetCount)
  var completedCycles = 0.obs; // Number of completed cycles
  var sessionTotal = 0.obs; // Total increments in this session

  Dhikr({
    required this.id,
    required this.name,
    required this.arabicText,
    required this.bengaliText,
    required this.meaning,
    required this.targetCount,
  });
}

class AdhkarController extends GetxController {
  late List<Dhikr> dhikrs;
  var totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeDhikrs();
  }

  void initializeDhikrs() {
    dhikrs = [
      Dhikr(
        id: 'subhanallah',
        name: 'سُبْحَانَ اللَّهِ',
        arabicText: 'سُبْحَانَ اللَّهِ',
        bengaliText: 'সুবহানাল্লাহ',
        meaning: 'আমি আল্লাহর শুদ্ধতা ঘোষণা করি',
        targetCount: 33,
      ),
      Dhikr(
        id: 'alhamdulillah',
        name: 'الْحَمْدُ لِلَّهِ',
        arabicText: 'الْحَمْدُ لِلَّهِ',
        bengaliText: 'আলহামদুলিল্লাহ',
        meaning: 'সকল প্রশংসা আল্লাহর জন্য',
        targetCount: 33,
      ),
      Dhikr(
        id: 'allahu_akbar',
        name: 'اللَّهُ أَكْبَر',
        arabicText: 'اللَّهُ أَكْبَر',
        bengaliText: 'আল্লাহু আকবার',
        meaning: 'আল্লাহ সর্বশ্রেষ্ঠ',
        targetCount: 33,
      ),
      Dhikr(
        id: 'la_ilaha',
        name: 'لا إله إلا الله',
        arabicText: 'لا إله إلا الله',
        bengaliText: 'লা ইলাহা ইল্লাল্লাহ',
        meaning: 'আল্লাহ ছাড়া কোনো ইলাহ নেই',
        targetCount: 100,
      ),
      Dhikr(
        id: 'astaghfirullah',
        name: 'أَسْتَغْفِرُ اللَّهَ',
        arabicText: 'أَسْتَغْفِرُ اللَّهَ',
        bengaliText: 'আস্তাগফিরুল্লাহ',
        meaning: 'আমি আল্লাহর কাছে ক্ষমা চাই',
        targetCount: 50,
      ),
      Dhikr(
        id: 'mashallah',
        name: 'ما شاء الله',
        arabicText: 'ما شاء الله',
        bengaliText: 'মাশাআল্লাহ',
        meaning: 'আল্লাহ যা চান তাই হয়',
        targetCount: 25,
      ),
      Dhikr(
        id: 'bismillah',
        name: 'بِسْمِ اللَّهِ',
        arabicText: 'بِسْمِ اللَّهِ',
        bengaliText: 'বিসমিল্লাহ',
        meaning: 'আল্লাহর নামে',
        targetCount: 30,
      ),
      Dhikr(
        id: 'allahumma',
        name: 'اللهم صل على محمد',
        arabicText: 'اللهم صل على محمد وآله وسلم',
        bengaliText: 'আল্লাহুম্মা সাল্লি আলা মুহাম্মাদ',
        meaning: 'হে আল্লাহ মুহাম্মাদের উপর দরুদ পাঠান',
        targetCount: 40,
      ),
    ];
  }

  void incrementCounter(int index) {
    dhikrs[index].count.value++;
    dhikrs[index].sessionTotal.value++;
    // When reaching target, increment completed cycles and reset for new cycle
    if (dhikrs[index].count.value > dhikrs[index].targetCount) {
      dhikrs[index].completedCycles.value++;
      dhikrs[index].count.value = 0;
    }
    updateTotalCount();
  }

  void decrementCounter(int index) {
    if (dhikrs[index].count.value > 0) {
      dhikrs[index].count.value--;
      dhikrs[index].sessionTotal.value--;
      updateTotalCount();
    }
  }

  void resetCounter(int index) {
    dhikrs[index].count.value = 0;
    dhikrs[index].completedCycles.value = 0;
    dhikrs[index].sessionTotal.value = 0;
    updateTotalCount();
  }

  void resetAllCounters() {
    for (var dhikr in dhikrs) {
      dhikr.count.value = 0;
      dhikr.completedCycles.value = 0;
      dhikr.sessionTotal.value = 0;
    }
    updateTotalCount();
  }

  void updateTotalCount() {
    totalCount.value = dhikrs.fold<int>(0, (sum, dhikr) => sum + dhikr.sessionTotal.value);
  }

  bool isTargetReached(int index) {
    return dhikrs[index].count.value >= dhikrs[index].targetCount;
  }

  double getProgressPercentage(int index) {
    return (dhikrs[index].count.value / dhikrs[index].targetCount) * 100;
  }
}
