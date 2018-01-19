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
    bleDataScanResultMessage.rssi = value[1][@"rssi"];
    return bleDataScanResultMessage;
}
@end

