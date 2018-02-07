#import <Foundation/Foundation.h>
#import "Bledata.pbobjc.h"

@interface Converter : NSObject

+ (BleDataLogLevelMessage)convertToBleDataLogLevelMessage:(NSNumber* _Nonnull)loglevel;

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessage:(NSNumber* _Nonnull)state;

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessageFromString:(NSString*)stateAsString;

+ (BleDataScanResultMessage* _Nonnull) convertToScanResultMessage:(id _Nonnull) value;

+ (BleDataBleDeviceMessage* _Nonnull) convertToBleDeviceMessage:(id _Nonnull) value;

+ (BleDataServiceMessages* _Nonnull) convertToBleDataServiceMessages:(id _Nonnull) value;

+ (BleDataServiceMessage* _Nonnull) convertBleDataServiceMessage: (id _Nonnull) value;

+ (BleDataCharacteristicMessages* _Nonnull) convertToBleDataCharacteristicMessages: (id _Nonnull) value;

+ (BleDataCharacteristicMessage* _Nonnull) convertToBleDataCharacteristicMessage: (id _Nonnull) value;

+ (BleDataMonitorCharacteristicMessage* _Nonnull)  conevrtToMonitorCharacteristicMessage: (id _Nonnull) value;

@end
