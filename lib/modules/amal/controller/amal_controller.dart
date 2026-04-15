import 'package:get/get.dart';
import 'dart:async';

class AmalController extends GetxController {
  // List of Islamic phrases to search for
  final List<String> phrases = ['সুবহানাল্লাহ', 'আলহামদুলিল্লাহ', 'আল্লাহু আকবার'];
  
  // Timer properties
  Timer? _timer;
  var timeRemaining = 30.obs;
  final int timerDuration = 30; // 30 seconds per paragraph
  var isTimerRunning = false.obs;
  
  // Current paragraph text
  var currentParagraph = ''.obs;
  
  // User counts
  var userCountSubhanallah = 0.obs;
  var userCountAlhamdulillah = 0.obs;
  var userCountAllahuAkbar = 0.obs;
  
  // Actual counts in paragraph
  var actualCountSubhanallah = 0;
  var actualCountAlhamdulillah = 0;
  var actualCountAllahuAkbar = 0;
  
  // Score
  var score = 0.0.obs;
  var isSubmitted = false.obs;

  @override
  void onInit() {
    super.onInit();
    generateNewParagraph();
    startTimer();
  }

  void startTimer() {
    isTimerRunning.value = true;
    timeRemaining.value = timerDuration;
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeRemaining.value--;
      
      if (timeRemaining.value <= 0) {
        // Auto generate new paragraph and reset timer
        generateNewParagraph();
        timeRemaining.value = timerDuration;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    isTimerRunning.value = false;
  }

  void generateNewParagraph() {
    // Generate random counts for each phrase (1-5 times)
    actualCountSubhanallah = (1 + (DateTime.now().millisecond % 5));
    actualCountAlhamdulillah = (1 + ((DateTime.now().millisecond + 100) % 5));
    actualCountAllahuAkbar = (1 + ((DateTime.now().millisecond + 200) % 5));

    // Build paragraph with the phrases repeated
    List<String> paragraphParts = [];
    
    // Different paragraphs to cycle through
    List<String> baseParagraphs = [
      'আমরা সকলে বিশ্বাস করি যে আল্লাহ তায়ালা সর্বশক্তিমান এবং সর্বজ্ঞানী।',
      'ইসলাম শান্তি এবং সমৃদ্ধির ধর্ম এবং আমরা এটি অনুসরণ করি।',
      'প্রতিদিন আমরা আল্লাহর কাছে কৃতজ্ঞতা প্রকাশ করি তার সীমাহীন নেয়ামতের জন্য।',
      'আল্লাহর বাণী আমাদের জীবনের পথ নির্দেশক এবং আলোর উৎস।',
    ];
    
    int randomIndex = DateTime.now().millisecond % baseParagraphs.length;
    paragraphParts.add(baseParagraphs[randomIndex]);

    // Add Subhanallah
    for (int i = 0; i < actualCountSubhanallah; i++) {
      paragraphParts.add('সুবহানাল্লাহ');
    }
    paragraphParts.add('আমাদের প্রতিটি কাজে আল্লাহর গুণগান করতে হবে।');

    // Add Alhamdulillah
    for (int i = 0; i < actualCountAlhamdulillah; i++) {
      paragraphParts.add('আলহামদুলিল্লাহ');
    }
    paragraphParts.add('প্রতিটি নিয়ামতের জন্য আমরা কৃতজ্ঞ।');

    // Add Allahu Akbar
    for (int i = 0; i < actualCountAllahuAkbar; i++) {
      paragraphParts.add('আল্লাহু আকবার');
    }
    paragraphParts.add('আল্লাহ আমাদের সকলের উপর রহম করুন এবং আমাদের সঠিক পথ দেখান।');

    currentParagraph.value = paragraphParts.join(' ');
    
    // Reset user inputs
    resetCounts();
    isSubmitted.value = false;
    score.value = 0.0;
  }

  void resetCounts() {
    userCountSubhanallah.value = 0;
    userCountAlhamdulillah.value = 0;
    userCountAllahuAkbar.value = 0;
  }

  void submitCounts() {
    // Calculate accuracy percentage
    int correctCounts = 0;
    
    if (userCountSubhanallah.value == actualCountSubhanallah) correctCounts++;
    if (userCountAlhamdulillah.value == actualCountAlhamdulillah) correctCounts++;
    if (userCountAllahuAkbar.value == actualCountAllahuAkbar) correctCounts++;
    
    // Calculate percentage (0-100 based on correct phrase counts)
    score.value = (correctCounts / 3) * 100;
    
    isSubmitted.value = true;
  }

  void incrementSubhanallah() {
    userCountSubhanallah.value++;
  }

  void decrementSubhanallah() {
    if (userCountSubhanallah.value > 0) {
      userCountSubhanallah.value--;
    }
  }

  void incrementAlhamdulillah() {
    userCountAlhamdulillah.value++;
  }

  void decrementAlhamdulillah() {
    if (userCountAlhamdulillah.value > 0) {
      userCountAlhamdulillah.value--;
    }
  }

  void incrementAllahuAkbar() {
    userCountAllahuAkbar.value++;
  }

  void decrementAllahuAkbar() {
    if (userCountAllahuAkbar.value > 0) {
      userCountAllahuAkbar.value--;
    }
  }

  String getResultMessage() {
    if (score.value == 100) {
      return 'মাশাআল্লাহ! পুরোপুরি সঠিক!';
    } else if (score.value >= 66) {
      return 'ভালো! আপনি বেশিরভাগ সঠিক পেয়েছেন।';
    } else if (score.value >= 33) {
      return 'সাধারণ। আরও মনোযোগ দিনতে হবে।';
    } else {
      return 'আবার চেষ্টা করুন!';
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
