import 'package:flutter/foundation.dart';

class ProfileImageState {
  static final ValueNotifier<Map<int, String?>> _notifier = ValueNotifier({});

  static ValueNotifier<Map<int, String?>> get notifier => _notifier;

  static void updateImage(int userId, String? imagePath) {
    _notifier.value = {..._notifier.value, userId: imagePath};
  }

  static String? getImage(int userId) {
    return _notifier.value[userId];
  }
}