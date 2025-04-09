import 'package:get/get.dart';

import 'translation_keys.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'bn_BD': bnBd,
      };
}