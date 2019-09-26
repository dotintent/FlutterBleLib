part of internal;

abstract class ChannelName {
  static String _base = "com.polidea.blemulator";
  static String upstream = "$_base/toDart";
  static String downstream = "$_base/toJava";
}

abstract class MethodName {
  static String simulate = "simulate";
}