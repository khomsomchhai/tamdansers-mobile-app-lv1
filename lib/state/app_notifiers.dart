import 'package:flutter/foundation.dart';

ValueNotifier<bool> homeworkChanged = ValueNotifier(false);

void notifyHomeworkChanged() {
  homeworkChanged.value = !homeworkChanged.value;
}