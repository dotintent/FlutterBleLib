#import <Foundation/Foundation.h>
#import "Bledata.pbobjc.h"

@interface Converter : NSObject

+ (BleDataLogLevelMessage)convertToBleDataLogLevelMessage:(NSNumber* _Nonnull)loglevel;

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessage:(NSNumber* _Nonnull)state;

+ (BleDataBluetoothStateMessage)convertToBleDataBluetoothStateMessageFromString:(NSString*)stateAsString;

+ (BleDataScanResultMessage* _Nonnull) convertToScanResultMessage:(id _Nonnull) value;

@end
