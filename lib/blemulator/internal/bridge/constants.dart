part of internal;

abstract class ChannelName {
  static String _base = "com.polidea.blemulator";
  static String upstream = "$_base/to_dart";
  static String downstream = "$_base/to_java";
}

abstract class MethodName {
  static String simulate = "simulate";
}