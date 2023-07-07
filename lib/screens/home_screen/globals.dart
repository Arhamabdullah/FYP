library globals;

import 'package:flutter/foundation.dart';

ValueNotifier<bool> isDisabled = ValueNotifier<bool>(false);
ValueNotifier<int> timer = ValueNotifier<int>(0);
ValueNotifier<int> quizDone = ValueNotifier<int>(0);
