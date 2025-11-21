import 'package:flutter_it/flutter_it.dart' show di;
import 'package:logging/logging.dart';

mixin HLoggerMixin {
  // This getter retrieves the singleton instance
  Logger get log => di<Logger>();
}
