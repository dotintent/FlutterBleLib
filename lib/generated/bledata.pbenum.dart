///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library bledata_pbenum;

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart';

class LogLevelMessage extends ProtobufEnum {
  static const LogLevelMessage VERBOSE = const LogLevelMessage._(0, 'VERBOSE');
  static const LogLevelMessage DEBUG = const LogLevelMessage._(1, 'DEBUG');
  static const LogLevelMessage INFO = const LogLevelMessage._(2, 'INFO');
  static const LogLevelMessage WARNING = const LogLevelMessage._(3, 'WARNING');
  static const LogLevelMessage ERROR = const LogLevelMessage._(4, 'ERROR');
  static const LogLevelMessage NONE = const LogLevelMessage._(5, 'NONE');

  static const List<LogLevelMessage> values = const <LogLevelMessage> [
    VERBOSE,
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    NONE,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static LogLevelMessage valueOf(int value) => _byValue[value] as LogLevelMessage;
  static void $checkItem(LogLevelMessage v) {
    if (v is! LogLevelMessage) checkItemFailed(v, 'LogLevelMessage');
  }

  const LogLevelMessage._(int v, String n) : super(v, n);
}

