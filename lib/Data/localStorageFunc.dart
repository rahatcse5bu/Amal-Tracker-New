import 'package:localstorage/localstorage.dart';

LocalStorage storage = new LocalStorage('ramadan_planner_1');

Future<void> setValueToLocalStorage(String key, value) async {
  return await storage.setItem(key, value);
}
