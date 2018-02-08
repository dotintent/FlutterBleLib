#import "Converter.h"
#import <flutter_ble_lib/flutter_ble_lib-Swift.h>

@implementation Converter

+ (BleDataLogLevelMessage)convertToBleDataLogLevelMessage:(NSNumber*)loglevel {
    switch (loglevel.intValue) {
        case 0: return BleDataLogLevelMessage_Verbose;
        case 1: return BleDataLogLevelMessage_Debug;
        case 2: return BleDataLogLevelMessage_Info;
        case 3: return BleDataLogLevelMessage_Warning;
        case 4: return BleDataLogLevelMessage_Error;
        default: return BleDataLogLevelMessage_None;
    }
}

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessage:(NSNumber*)state {
    switch (state.intValue) {
        case 1: return BleDataBluetoothStateMessage_Resetting;
        case 2: return BleDataBluetoothStateMessage_Unsupported;
        case 3: return BleDataBluetoothStateMessage_Unauthorized;
        case 4: return BleDataBluetoothStateMessage_PoweredOff;
        case 5: return BleDataBluetoothStateMessage_PoweredOn;
        default: return BleDataBluetoothStateMessage_Unknown;
    }
}

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessageFromString:(NSString*)stateAsString {
    if([@"Resetting"isEqualToString: stateAsString]) {
        return BleDataBluetoothStateMessage_Resetting;
    }else if([@"Unsupported" isEqualToString:  stateAsString]){
        return BleDataBluetoothStateMessage_Unsupported;
        
    }else if([@"Unauthorized" isEqualToString:  stateAsString]){
        return BleDataBluetoothStateMessage_Unauthorized;
        
    }else if([@"PoweredOff" isEqualToString:  stateAsString]){
        return BleDataBluetoothStateMessage_PoweredOff;
        
    }else if([@"PoweredOn" isEqualToString:  stateAsString]){
        return BleDataBluetoothStateMessage_PoweredOn;
        
    }else {
        return BleDataBluetoothStateMessage_Unknown;
    }
}

+ (BleDataScanResultMessage*) convertToScanResultMessage:(id _Nonnull) value {
    BleDataScanResultMessage* bleDataScanResultMessage = [[BleDataScanResultMessage alloc] init];
    //TODO add check for value length
    bleDataScanResultMessage.rssi = value[1][@"rssi"];
    bleDataScanResultMessage.bleDeviceMessage = [[BleDataBleDeviceMessage alloc] init];
    bleDataScanResultMessage.bleDeviceMessage.macAddress = value[1][@"id"];
    NSString* name = value[1][@"name"];
    if(name != (id)[NSNull null]){
        bleDataScanResultMessage.bleDeviceMessage.name = name;
    }
    bleDataScanResultMessage.bleDeviceMessage.rssi = value[1][@"rssi"];
    bleDataScanResultMessage.bleDeviceMessage.mtu = value[1][@"mtu"];
    return bleDataScanResultMessage;
}


+ (BleDataBleDeviceMessage* _Nonnull) convertToBleDeviceMessage:(id _Nonnull) value {
    BleDataBleDeviceMessage* bleDataBleDeviceMessage = [[BleDataBleDeviceMessage alloc] init];
    bleDataBleDeviceMessage.macAddress = value[@"id"];
    NSString* name = value[@"name"];
    if(name != (id)[NSNull null]){
        bleDataBleDeviceMessage.name = name;
    }
    bleDataBleDeviceMessage.rssi = value[@"rssi"];
    bleDataBleDeviceMessage.mtu = value[@"mtu"];
    return bleDataBleDeviceMessage;
}

+ (BleDataServiceMessages* _Nonnull) convertToBleDataServiceMessages:(id _Nonnull) value {
    BleDataServiceMessages* bleDataServiceMessages = [[BleDataServiceMessages alloc] init];
    for(int index =0; index < [value count]; index++) {
        BleDataBleDeviceMessage* bleDataServiceMessage = [Converter convertBleDataServiceMessage: value[index]];
        [bleDataServiceMessages.serviceMessagesArray addObject: bleDataServiceMessage];
    }
    return bleDataServiceMessages;
}

+ (BleDataServiceMessage* _Nonnull) convertBleDataServiceMessage: (id _Nonnull) value {
    BleDataServiceMessage* bleDataServiceMessage = [[BleDataServiceMessage alloc] init];
    bleDataServiceMessage.id_p = ((NSNumber *) value[@"id"]).intValue;
    bleDataServiceMessage.device =  [[BleDataBleDeviceMessage alloc] init];
    bleDataServiceMessage.device.macAddress = value[@"deviceID"];
    bleDataServiceMessage.uuid = value[@"uuid"];
    bleDataServiceMessage.isPrimary = value[@"isPrimary"];
    
    return bleDataServiceMessage;
}

+ (BleDataCharacteristicMessages* _Nonnull) convertToBleDataCharacteristicMessages: (id _Nonnull) value {
    BleDataCharacteristicMessages* bleDataCharacteristicMessages = [[BleDataCharacteristicMessages alloc] init];
    for(int index =0; index < [value count]; index++) {
        BleDataCharacteristicMessage* bleDataCharacteristicMessage = [Converter convertToBleDataCharacteristicMessage: value[index]];
        [bleDataCharacteristicMessages.characteristicMessageArray addObject: bleDataCharacteristicMessage];
    }
    return bleDataCharacteristicMessages;
}

+ (BleDataCharacteristicMessage* _Nonnull) convertToBleDataCharacteristicMessage: (id _Nonnull) value {
    BleDataCharacteristicMessage* bleDataCharacteristicMessage = [[BleDataCharacteristicMessage alloc] init];
    bleDataCharacteristicMessage.id_p = value[@"id"];
    bleDataCharacteristicMessage.uuid = value[@"uuid"];
    bleDataCharacteristicMessage.deviceId = value[@"deviceID"];
    bleDataCharacteristicMessage.serviceUuid = value[@"serviceUUID"];
    bleDataCharacteristicMessage.serviceId = value[@"serviceID"];
    bleDataCharacteristicMessage.isIndicatable = [self convertToBOOL:value[@"isIndicatable"]];
    bleDataCharacteristicMessage.isNotificable = [self convertToBOOL:value[@"isNotifiable"]];
    bleDataCharacteristicMessage.isNotifing = [self convertToBOOL:value[@"isNotifying"]];
    bleDataCharacteristicMessage.isReadable =  [self convertToBOOL:value[@"isReadable"]];
    bleDataCharacteristicMessage.isWritableWithResponse = [self convertToBOOL:value[@"isWritableWithResponse"]];
    bleDataCharacteristicMessage.isWritableWithoutResponse = [self convertToBOOL:value[@"isWritableWithoutResponse"]];
    NSString* valueData = value[@"value"];
    if(valueData != (id)[NSNull null]){
        bleDataCharacteristicMessage.value = valueData;
    }
    return bleDataCharacteristicMessage;
}

+ (BleDataMonitorCharacteristicMessage * _Nonnull)  conevrtToMonitorCharacteristicMessage: (id _Nonnull) value {
    BleDataMonitorCharacteristicMessage* bleDataMonitorCharacteristicMessage = [[BleDataMonitorCharacteristicMessage alloc] init];
    return bleDataMonitorCharacteristicMessage;
}

+ (BOOL) convertToBOOL: (id _Nonnull) value {
    return [((NSNumber *) value).stringValue isEqualToString: @"1"];
}
@end

