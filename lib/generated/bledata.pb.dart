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

class ScanSettingsMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ScanSettingsMessage')
    ..a<int>(1, 'scanMode', PbFieldType.O3)
    ..a<int>(2, 'callbackType', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ScanSettingsMessage() : super();
  ScanSettingsMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ScanSettingsMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ScanSettingsMessage clone() => new ScanSettingsMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ScanSettingsMessage create() => new ScanSettingsMessage();
  static PbList<ScanSettingsMessage> createRepeated() => new PbList<ScanSettingsMessage>();
  static ScanSettingsMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyScanSettingsMessage();
    return _defaultInstance;
  }
  static ScanSettingsMessage _defaultInstance;
  static void $checkItem(ScanSettingsMessage v) {
    if (v is! ScanSettingsMessage) checkItemFailed(v, 'ScanSettingsMessage');
  }

  int get scanMode => $_get(0, 1, 0);
  set scanMode(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasScanMode() => $_has(0, 1);
  void clearScanMode() => clearField(1);

  int get callbackType => $_get(1, 2, 0);
  set callbackType(int v) { $_setUnsignedInt32(1, 2, v); }
  bool hasCallbackType() => $_has(1, 2);
  void clearCallbackType() => clearField(2);
}

class _ReadonlyScanSettingsMessage extends ScanSettingsMessage with ReadonlyMessageMixin {}

class ScanFilterMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ScanFilterMessage')
    ..a<String>(1, 'deviceName', PbFieldType.OS)
    ..a<String>(2, 'deviceAddress', PbFieldType.OS)
    ..a<String>(3, 'serviceUuid', PbFieldType.OS)
    ..a<String>(4, 'serviceUuidMask', PbFieldType.OS)
    ..a<String>(5, 'serviceDataUuid', PbFieldType.OS)
    ..a<List<int>>(6, 'serviceData', PbFieldType.OY)
    ..a<List<int>>(7, 'serviceDataMask', PbFieldType.OY)
    ..a<int>(8, 'manufacturerId', PbFieldType.O3)
    ..a<List<int>>(9, 'manufacturerData', PbFieldType.OY)
    ..a<List<int>>(10, 'manufacturerDataMask', PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  ScanFilterMessage() : super();
  ScanFilterMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ScanFilterMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ScanFilterMessage clone() => new ScanFilterMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ScanFilterMessage create() => new ScanFilterMessage();
  static PbList<ScanFilterMessage> createRepeated() => new PbList<ScanFilterMessage>();
  static ScanFilterMessage getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyScanFilterMessage();
    return _defaultInstance;
  }
  static ScanFilterMessage _defaultInstance;
  static void $checkItem(ScanFilterMessage v) {
    if (v is! ScanFilterMessage) checkItemFailed(v, 'ScanFilterMessage');
  }

  String get deviceName => $_get(0, 1, '');
  set deviceName(String v) { $_setString(0, 1, v); }
  bool hasDeviceName() => $_has(0, 1);
  void clearDeviceName() => clearField(1);

  String get deviceAddress => $_get(1, 2, '');
  set deviceAddress(String v) { $_setString(1, 2, v); }
  bool hasDeviceAddress() => $_has(1, 2);
  void clearDeviceAddress() => clearField(2);

  String get serviceUuid => $_get(2, 3, '');
  set serviceUuid(String v) { $_setString(2, 3, v); }
  bool hasServiceUuid() => $_has(2, 3);
  void clearServiceUuid() => clearField(3);

  String get serviceUuidMask => $_get(3, 4, '');
  set serviceUuidMask(String v) { $_setString(3, 4, v); }
  bool hasServiceUuidMask() => $_has(3, 4);
  void clearServiceUuidMask() => clearField(4);

  String get serviceDataUuid => $_get(4, 5, '');
  set serviceDataUuid(String v) { $_setString(4, 5, v); }
  bool hasServiceDataUuid() => $_has(4, 5);
  void clearServiceDataUuid() => clearField(5);

  List<int> get serviceData => $_get(5, 6, null);
  set serviceData(List<int> v) { $_setBytes(5, 6, v); }
  bool hasServiceData() => $_has(5, 6);
  void clearServiceData() => clearField(6);

  List<int> get serviceDataMask => $_get(6, 7, null);
  set serviceDataMask(List<int> v) { $_setBytes(6, 7, v); }
  bool hasServiceDataMask() => $_has(6, 7);
  void clearServiceDataMask() => clearField(7);

  int get manufacturerId => $_get(7, 8, 0);
  set manufacturerId(int v) { $_setUnsignedInt32(7, 8, v); }
  bool hasManufacturerId() => $_has(7, 8);
  void clearManufacturerId() => clearField(8);

  List<int> get manufacturerData => $_get(8, 9, null);
  set manufacturerData(List<int> v) { $_setBytes(8, 9, v); }
  bool hasManufacturerData() => $_has(8, 9);
  void clearManufacturerData() => clearField(9);

  List<int> get manufacturerDataMask => $_get(9, 10, null);
  set manufacturerDataMask(List<int> v) { $_setBytes(9, 10, v); }
  bool hasManufacturerDataMask() => $_has(9, 10);
  void clearManufacturerDataMask() => clearField(10);
}

class _ReadonlyScanFilterMessage extends ScanFilterMessage with ReadonlyMessageMixin {}

class BleDeviceMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('BleDeviceMessage')
    ..a<String>(1, 'macAddress', PbFieldType.OS)
    ..a<String>(2, 'name', PbFieldType.OS)
    ..a<int>(3, 'rssi', PbFieldType.O3)
    ..a<int>(4, 'mtu', PbFieldType.O3)
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

  String get macAddress => $_get(0, 1, '');
  set macAddress(String v) { $_setString(0, 1, v); }
  bool hasMacAddress() => $_has(0, 1);
  void clearMacAddress() => clearField(1);

  String get name => $_get(1, 2, '');
  set name(String v) { $_setString(1, 2, v); }
  bool hasName() => $_has(1, 2);
  void clearName() => clearField(2);

  int get rssi => $_get(2, 3, 0);
  set rssi(int v) { $_setUnsignedInt32(2, 3, v); }
  bool hasRssi() => $_has(2, 3);
  void clearRssi() => clearField(3);

  int get mtu => $_get(3, 4, 0);
  set mtu(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasMtu() => $_has(3, 4);
  void clearMtu() => clearField(4);
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

  BleDeviceMessage get bleDeviceMessage => $_get(0, 1, null);
  set bleDeviceMessage(BleDeviceMessage v) { setField(1, v); }
  bool hasBleDeviceMessage() => $_has(0, 1);
  void clearBleDeviceMessage() => clearField(1);

  int get rssi => $_get(1, 2, 0);
  set rssi(int v) { $_setUnsignedInt32(1, 2, v); }
  bool hasRssi() => $_has(1, 2);
  void clearRssi() => clearField(2);

  Int64 get timestampNanos => $_get(2, 3, null);
  set timestampNanos(Int64 v) { $_setInt64(2, 3, v); }
  bool hasTimestampNanos() => $_has(2, 3);
  void clearTimestampNanos() => clearField(3);

  int get scanCallbackTypeMessage => $_get(3, 4, 0);
  set scanCallbackTypeMessage(int v) { $_setUnsignedInt32(3, 4, v); }
  bool hasScanCallbackTypeMessage() => $_has(3, 4);
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

  String get macAddress => $_get(0, 1, '');
  set macAddress(String v) { $_setString(0, 1, v); }
  bool hasMacAddress() => $_has(0, 1);
  void clearMacAddress() => clearField(1);

  bool get isAutoConnect => $_get(1, 2, false);
  set isAutoConnect(bool v) { $_setBool(1, 2, v); }
  bool hasIsAutoConnect() => $_has(1, 2);
  void clearIsAutoConnect() => clearField(2);

  int get requestMtu => $_get(2, 3, 0);
  set requestMtu(int v) { $_setUnsignedInt32(2, 3, v); }
  bool hasRequestMtu() => $_has(2, 3);
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

  List<ServiceMessage> get serviceMessages => $_get(0, 1, null);
}

class _ReadonlyServiceMessages extends ServiceMessages with ReadonlyMessageMixin {}

class ServiceMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceMessage')
    ..a<int>(1, 'id', PbFieldType.O3)
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

  int get id => $_get(0, 1, 0);
  set id(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get uuid => $_get(1, 2, '');
  set uuid(String v) { $_setString(1, 2, v); }
  bool hasUuid() => $_has(1, 2);
  void clearUuid() => clearField(2);

  BleDeviceMessage get device => $_get(2, 3, null);
  set device(BleDeviceMessage v) { setField(3, v); }
  bool hasDevice() => $_has(2, 3);
  void clearDevice() => clearField(3);

  bool get isPrimary => $_get(3, 4, false);
  set isPrimary(bool v) { $_setBool(3, 4, v); }
  bool hasIsPrimary() => $_has(3, 4);
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

  List<CharacteristicMessage> get characteristicMessage => $_get(0, 1, null);
}

class _ReadonlyCharacteristicMessages extends CharacteristicMessages with ReadonlyMessageMixin {}

class CharacteristicMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CharacteristicMessage')
    ..a<int>(1, 'id', PbFieldType.O3)
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

  int get id => $_get(0, 1, 0);
  set id(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasId() => $_has(0, 1);
  void clearId() => clearField(1);

  String get uuid => $_get(1, 2, '');
  set uuid(String v) { $_setString(1, 2, v); }
  bool hasUuid() => $_has(1, 2);
  void clearUuid() => clearField(2);

  int get serviceId => $_get(2, 3, 0);
  set serviceId(int v) { $_setUnsignedInt32(2, 3, v); }
  bool hasServiceId() => $_has(2, 3);
  void clearServiceId() => clearField(3);

  String get serviceUuid => $_get(3, 4, '');
  set serviceUuid(String v) { $_setString(3, 4, v); }
  bool hasServiceUuid() => $_has(3, 4);
  void clearServiceUuid() => clearField(4);

  String get deviceId => $_get(4, 5, '');
  set deviceId(String v) { $_setString(4, 5, v); }
  bool hasDeviceId() => $_has(4, 5);
  void clearDeviceId() => clearField(5);

  bool get isReadable => $_get(5, 6, false);
  set isReadable(bool v) { $_setBool(5, 6, v); }
  bool hasIsReadable() => $_has(5, 6);
  void clearIsReadable() => clearField(6);

  bool get isWritableWithResponse => $_get(6, 7, false);
  set isWritableWithResponse(bool v) { $_setBool(6, 7, v); }
  bool hasIsWritableWithResponse() => $_has(6, 7);
  void clearIsWritableWithResponse() => clearField(7);

  bool get isWritableWithoutResponse => $_get(7, 8, false);
  set isWritableWithoutResponse(bool v) { $_setBool(7, 8, v); }
  bool hasIsWritableWithoutResponse() => $_has(7, 8);
  void clearIsWritableWithoutResponse() => clearField(8);

  bool get isNotificable => $_get(8, 9, false);
  set isNotificable(bool v) { $_setBool(8, 9, v); }
  bool hasIsNotificable() => $_has(8, 9);
  void clearIsNotificable() => clearField(9);

  bool get isIndicatable => $_get(9, 10, false);
  set isIndicatable(bool v) { $_setBool(9, 10, v); }
  bool hasIsIndicatable() => $_has(9, 10);
  void clearIsIndicatable() => clearField(10);

  bool get isNotifing => $_get(10, 11, false);
  set isNotifing(bool v) { $_setBool(10, 11, v); }
  bool hasIsNotifing() => $_has(10, 11);
  void clearIsNotifing() => clearField(11);

  String get value => $_get(11, 12, '');
  set value(String v) { $_setString(11, 12, v); }
  bool hasValue() => $_has(11, 12);
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

  String get transactionId => $_get(0, 1, '');
  set transactionId(String v) { $_setString(0, 1, v); }
  bool hasTransactionId() => $_has(0, 1);
  void clearTransactionId() => clearField(1);

  CharacteristicMessage get characteristicMessage => $_get(1, 2, null);
  set characteristicMessage(CharacteristicMessage v) { setField(2, v); }
  bool hasCharacteristicMessage() => $_has(1, 2);
  void clearCharacteristicMessage() => clearField(2);
}

class _ReadonlyMonitorCharacteristicMessage extends MonitorCharacteristicMessage with ReadonlyMessageMixin {}

