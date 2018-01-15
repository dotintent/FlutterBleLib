//
//  Converter.m
//  flutter_ble_lib
//
//  Created by Konrad Krakowiak on 17/01/2018.
//

#import "Converter.h"
#import "BleData/Bledata.pbobjc.h"
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
@end

