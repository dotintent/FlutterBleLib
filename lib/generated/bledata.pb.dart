///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library bledata;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

export 'bledata.pbenum.dart';

class ScanDataMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ScanDataMessage')
    ..a<int>(1, 'scanMode', PbFieldType.O3)
    ..a<int>(2, 'callbackType', PbFieldType.O3)
    ..p<String>(3, 'uuids', PbFieldType.PS)
    ..hasRequiredFields = false
  ;

  ScanDataMessage() : super();
  ScanDataMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ScanDataMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ScanDataMessage clone() => new ScanDataMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ScanDataMessage create() => new ScanDataMessage();
  static PbList<ScanDataMessage> createRepeated() => new PbList<ScanDataMessage>();
  static ScanDataMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyScanDataMessage();
    return _defaultInstance;
  }
  static ScanDataMessage _defaultInstance;
  static void $checkItem(ScanDataMessage v) {
    if (v is! ScanDataMessage) checkItemFailed(v, 'ScanDataMessage');
  }

  int get scanMode => $_get(0, 0);
  set scanMode(int v) { $_setUnsignedInt32(0, v); }
  bool hasScanMode() => $_has(0);
  void clearScanMode() => clearField(1);

  int get callbackType => $_get(1, 0);
  set callbackType(int v) { $_setUnsignedInt32(1, v); }
  bool hasCallbackType() => $_has(1);
  void clearCallbackType() => clearField(2);

  List<String> get uuids => $_get(2, null);
}

class _ReadonlyScanDataMessage extends ScanDataMessage with ReadonlyMessageMixin {}

class BleDeviceMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('BleDeviceMessage')
    ..a<String>(1, 'id', PbFieldType.OS)
    ..a<String>(2, 'name', PbFieldType.OS)
    ..a<int>(3, 'rssi', PbFieldType.O3)
    ..a<int>(4, 'mtu', PbFieldType.O3)
    ..a<bool>(5, 'isConnected', PbFieldType.OB)
    ..hasRequiredFields = false
  ;

  BleDeviceMessage() : super();
  BleDeviceMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  BleDeviceMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  BleDeviceMessage clone() => new BleDeviceMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static BleDeviceMessage create() => new BleDeviceMessage();
  static PbList<BleDeviceMessage> createRepeated() => new PbList<BleDeviceMessage>();
  static BleDeviceMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyBleDeviceMessage();
    return _defaultInstance;
  }
  static BleDeviceMessage _defaultInstance;
  static void $checkItem(BleDeviceMessage v) {
    if (v is! BleDeviceMessage) checkItemFailed(v, 'BleDeviceMessage');
  }

  String get id => $_get(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get name => $_get(1, '');
  set name(String v) { $_setString(1, v); }
  bool hasName() => $_has(1);
  void clearName() => clearField(2);

  int get rssi => $_get(2, 0);
  set rssi(int v) { $_setUnsignedInt32(2, v); }
  bool hasRssi() => $_has(2);
  void clearRssi() => clearField(3);

  int get mtu => $_get(3, 0);
  set mtu(int v) { $_setUnsignedInt32(3, v); }
  bool hasMtu() => $_has(3);
  void clearMtu() => clearField(4);

  bool get isConnected => $_get(4, false);
  set isConnected(bool v) { $_setBool(4, v); }
  bool hasIsConnected() => $_has(4);
  void clearIsConnected() => clearField(5);
}

class _ReadonlyBleDeviceMessage extends BleDeviceMessage with ReadonlyMessageMixin {}

class ScanResultMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ScanResultMessage')
    ..a<BleDeviceMessage>(1, 'bleDeviceMessage', PbFieldType.OM, BleDeviceMessage.getDefault, BleDeviceMessage.create)
    ..a<int>(2, 'rssi', PbFieldType.O3)
    ..a<Int64>(3, 'timestampNanos', PbFieldType.OU6, Int64.ZERO)
    ..a<int>(4, 'scanCallbackTypeMessage', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ScanResultMessage() : super();
  ScanResultMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ScanResultMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ScanResultMessage clone() => new ScanResultMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ScanResultMessage create() => new ScanResultMessage();
  static PbList<ScanResultMessage> createRepeated() => new PbList<ScanResultMessage>();
  static ScanResultMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyScanResultMessage();
    return _defaultInstance;
  }
  static ScanResultMessage _defaultInstance;
  static void $checkItem(ScanResultMessage v) {
    if (v is! ScanResultMessage) checkItemFailed(v, 'ScanResultMessage');
  }

  BleDeviceMessage get bleDeviceMessage => $_get(0, null);
  set bleDeviceMessage(BleDeviceMessage v) { setField(1, v); }
  bool hasBleDeviceMessage() => $_has(0);
  void clearBleDeviceMessage() => clearField(1);

  int get rssi => $_get(1, 0);
  set rssi(int v) { $_setUnsignedInt32(1, v); }
  bool hasRssi() => $_has(1);
  void clearRssi() => clearField(2);

  Int64 get timestampNanos => $_get(2, null);
  set timestampNanos(Int64 v) { $_setInt64(2, v); }
  bool hasTimestampNanos() => $_has(2);
  void clearTimestampNanos() => clearField(3);

  int get scanCallbackTypeMessage => $_get(3, 0);
  set scanCallbackTypeMessage(int v) { $_setUnsignedInt32(3, v); }
  bool hasScanCallbackTypeMessage() => $_has(3);
  void clearScanCallbackTypeMessage() => clearField(4);
}

class _ReadonlyScanResultMessage extends ScanResultMessage with ReadonlyMessageMixin {}

class ConnectToDeviceDataMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ConnectToDeviceDataMessage')
    ..a<String>(1, 'macAddress', PbFieldType.OS)
    ..a<bool>(2, 'isAutoConnect', PbFieldType.OB)
    ..a<int>(3, 'requestMtu', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ConnectToDeviceDataMessage() : super();
  ConnectToDeviceDataMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ConnectToDeviceDataMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ConnectToDeviceDataMessage clone() => new ConnectToDeviceDataMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ConnectToDeviceDataMessage create() => new ConnectToDeviceDataMessage();
  static PbList<ConnectToDeviceDataMessage> createRepeated() => new PbList<ConnectToDeviceDataMessage>();
  static ConnectToDeviceDataMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyConnectToDeviceDataMessage();
    return _defaultInstance;
  }
  static ConnectToDeviceDataMessage _defaultInstance;
  static void $checkItem(ConnectToDeviceDataMessage v) {
    if (v is! ConnectToDeviceDataMessage) checkItemFailed(v, 'ConnectToDeviceDataMessage');
  }

  String get macAddress => $_get(0, '');
  set macAddress(String v) { $_setString(0, v); }
  bool hasMacAddress() => $_has(0);
  void clearMacAddress() => clearField(1);

  bool get isAutoConnect => $_get(1, false);
  set isAutoConnect(bool v) { $_setBool(1, v); }
  bool hasIsAutoConnect() => $_has(1);
  void clearIsAutoConnect() => clearField(2);

  int get requestMtu => $_get(2, 0);
  set requestMtu(int v) { $_setUnsignedInt32(2, v); }
  bool hasRequestMtu() => $_has(2);
  void clearRequestMtu() => clearField(3);
}

class _ReadonlyConnectToDeviceDataMessage extends ConnectToDeviceDataMessage with ReadonlyMessageMixin {}

class ServiceMessages extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceMessages')
    ..pp<ServiceMessage>(1, 'serviceMessages', PbFieldType.PM, ServiceMessage.$checkItem, ServiceMessage.create)
    ..hasRequiredFields = false
  ;

  ServiceMessages() : super();
  ServiceMessages.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceMessages.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceMessages clone() => new ServiceMessages()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceMessages create() => new ServiceMessages();
  static PbList<ServiceMessages> createRepeated() => new PbList<ServiceMessages>();
  static ServiceMessages getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyServiceMessages();
    return _defaultInstance;
  }
  static ServiceMessages _defaultInstance;
  static void $checkItem(ServiceMessages v) {
    if (v is! ServiceMessages) checkItemFailed(v, 'ServiceMessages');
  }

  List<ServiceMessage> get serviceMessages => $_get(0, null);
}

class _ReadonlyServiceMessages extends ServiceMessages with ReadonlyMessageMixin {}

class ServiceMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceMessage')
    ..a<double>(1, 'id', PbFieldType.OD)
    ..a<String>(2, 'uuid', PbFieldType.OS)
    ..a<BleDeviceMessage>(3, 'device', PbFieldType.OM, BleDeviceMessage.getDefault, BleDeviceMessage.create)
    ..a<bool>(4, 'isPrimary', PbFieldType.OB)
    ..hasRequiredFields = false
  ;

  ServiceMessage() : super();
  ServiceMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceMessage clone() => new ServiceMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceMessage create() => new ServiceMessage();
  static PbList<ServiceMessage> createRepeated() => new PbList<ServiceMessage>();
  static ServiceMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyServiceMessage();
    return _defaultInstance;
  }
  static ServiceMessage _defaultInstance;
  static void $checkItem(ServiceMessage v) {
    if (v is! ServiceMessage) checkItemFailed(v, 'ServiceMessage');
  }

  double get id => $_get(0, null);
  set id(double v) { $_setDouble(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get uuid => $_get(1, '');
  set uuid(String v) { $_setString(1, v); }
  bool hasUuid() => $_has(1);
  void clearUuid() => clearField(2);

  BleDeviceMessage get device => $_get(2, null);
  set device(BleDeviceMessage v) { setField(3, v); }
  bool hasDevice() => $_has(2);
  void clearDevice() => clearField(3);

  bool get isPrimary => $_get(3, false);
  set isPrimary(bool v) { $_setBool(3, v); }
  bool hasIsPrimary() => $_has(3);
  void clearIsPrimary() => clearField(4);
}

class _ReadonlyServiceMessage extends ServiceMessage with ReadonlyMessageMixin {}

class CharacteristicMessages extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CharacteristicMessages')
    ..pp<CharacteristicMessage>(1, 'characteristicMessage', PbFieldType.PM, CharacteristicMessage.$checkItem, CharacteristicMessage.create)
    ..hasRequiredFields = false
  ;

  CharacteristicMessages() : super();
  CharacteristicMessages.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CharacteristicMessages.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CharacteristicMessages clone() => new CharacteristicMessages()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CharacteristicMessages create() => new CharacteristicMessages();
  static PbList<CharacteristicMessages> createRepeated() => new PbList<CharacteristicMessages>();
  static CharacteristicMessages getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCharacteristicMessages();
    return _defaultInstance;
  }
  static CharacteristicMessages _defaultInstance;
  static void $checkItem(CharacteristicMessages v) {
    if (v is! CharacteristicMessages) checkItemFailed(v, 'CharacteristicMessages');
  }

  List<CharacteristicMessage> get characteristicMessage => $_get(0, null);
}

class _ReadonlyCharacteristicMessages extends CharacteristicMessages with ReadonlyMessageMixin {}

class CharacteristicMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CharacteristicMessage')
    ..a<double>(1, 'id', PbFieldType.OD)
    ..a<String>(2, 'uuid', PbFieldType.OS)
    ..a<int>(3, 'serviceId', PbFieldType.O3)
    ..a<String>(4, 'serviceUuid', PbFieldType.OS)
    ..a<String>(5, 'deviceId', PbFieldType.OS)
    ..a<bool>(6, 'isReadable', PbFieldType.OB)
    ..a<bool>(7, 'isWritableWithResponse', PbFieldType.OB)
    ..a<bool>(8, 'isWritableWithoutResponse', PbFieldType.OB)
    ..a<bool>(9, 'isNotificable', PbFieldType.OB)
    ..a<bool>(10, 'isIndicatable', PbFieldType.OB)
    ..a<bool>(11, 'isNotifing', PbFieldType.OB)
    ..a<String>(12, 'value', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  CharacteristicMessage() : super();
  CharacteristicMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CharacteristicMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CharacteristicMessage clone() => new CharacteristicMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CharacteristicMessage create() => new CharacteristicMessage();
  static PbList<CharacteristicMessage> createRepeated() => new PbList<CharacteristicMessage>();
  static CharacteristicMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCharacteristicMessage();
    return _defaultInstance;
  }
  static CharacteristicMessage _defaultInstance;
  static void $checkItem(CharacteristicMessage v) {
    if (v is! CharacteristicMessage) checkItemFailed(v, 'CharacteristicMessage');
  }

  double get id => $_get(0, null);
  set id(double v) { $_setDouble(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  String get uuid => $_get(1, '');
  set uuid(String v) { $_setString(1, v); }
  bool hasUuid() => $_has(1);
  void clearUuid() => clearField(2);

  int get serviceId => $_get(2, 0);
  set serviceId(int v) { $_setUnsignedInt32(2, v); }
  bool hasServiceId() => $_has(2);
  void clearServiceId() => clearField(3);

  String get serviceUuid => $_get(3, '');
  set serviceUuid(String v) { $_setString(3, v); }
  bool hasServiceUuid() => $_has(3);
  void clearServiceUuid() => clearField(4);

  String get deviceId => $_get(4, '');
  set deviceId(String v) { $_setString(4, v); }
  bool hasDeviceId() => $_has(4);
  void clearDeviceId() => clearField(5);

  bool get isReadable => $_get(5, false);
  set isReadable(bool v) { $_setBool(5, v); }
  bool hasIsReadable() => $_has(5);
  void clearIsReadable() => clearField(6);

  bool get isWritableWithResponse => $_get(6, false);
  set isWritableWithResponse(bool v) { $_setBool(6, v); }
  bool hasIsWritableWithResponse() => $_has(6);
  void clearIsWritableWithResponse() => clearField(7);

  bool get isWritableWithoutResponse => $_get(7, false);
  set isWritableWithoutResponse(bool v) { $_setBool(7, v); }
  bool hasIsWritableWithoutResponse() => $_has(7);
  void clearIsWritableWithoutResponse() => clearField(8);

  bool get isNotificable => $_get(8, false);
  set isNotificable(bool v) { $_setBool(8, v); }
  bool hasIsNotificable() => $_has(8);
  void clearIsNotificable() => clearField(9);

  bool get isIndicatable => $_get(9, false);
  set isIndicatable(bool v) { $_setBool(9, v); }
  bool hasIsIndicatable() => $_has(9);
  void clearIsIndicatable() => clearField(10);

  bool get isNotifing => $_get(10, false);
  set isNotifing(bool v) { $_setBool(10, v); }
  bool hasIsNotifing() => $_has(10);
  void clearIsNotifing() => clearField(11);

  String get value => $_get(11, '');
  set value(String v) { $_setString(11, v); }
  bool hasValue() => $_has(11);
  void clearValue() => clearField(12);
}

class _ReadonlyCharacteristicMessage extends CharacteristicMessage with ReadonlyMessageMixin {}

class MonitorCharacteristicMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MonitorCharacteristicMessage')
    ..a<String>(1, 'transactionId', PbFieldType.OS)
    ..a<CharacteristicMessage>(2, 'characteristicMessage', PbFieldType.OM, CharacteristicMessage.getDefault, CharacteristicMessage.create)
    ..hasRequiredFields = false
  ;

  MonitorCharacteristicMessage() : super();
  MonitorCharacteristicMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MonitorCharacteristicMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MonitorCharacteristicMessage clone() => new MonitorCharacteristicMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MonitorCharacteristicMessage create() => new MonitorCharacteristicMessage();
  static PbList<MonitorCharacteristicMessage> createRepeated() => new PbList<MonitorCharacteristicMessage>();
  static MonitorCharacteristicMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyMonitorCharacteristicMessage();
    return _defaultInstance;
  }
  static MonitorCharacteristicMessage _defaultInstance;
  static void $checkItem(MonitorCharacteristicMessage v) {
    if (v is! MonitorCharacteristicMessage) checkItemFailed(v, 'MonitorCharacteristicMessage');
  }

  String get transactionId => $_get(0, '');
  set transactionId(String v) { $_setString(0, v); }
  bool hasTransactionId() => $_has(0);
  void clearTransactionId() => clearField(1);

  CharacteristicMessage get characteristicMessage => $_get(1, null);
  set characteristicMessage(CharacteristicMessage v) { setField(2, v); }
  bool hasCharacteristicMessage() => $_has(1);
  void clearCharacteristicMessage() => clearField(2);
}

class _ReadonlyMonitorCharacteristicMessage extends MonitorCharacteristicMessage with ReadonlyMessageMixin {}

