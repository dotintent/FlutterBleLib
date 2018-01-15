//
//  Converter.h
//  flutter_ble_lib
//
//  Created by Konrad Krakowiak on 17/01/2018.
//

#import <Foundation/Foundation.h>
#import "BleData/Bledata.pbobjc.h"

@interface Converter : NSObject

+ (BleDataLogLevelMessage)convertToBleDataLogLevelMessage:(NSNumber*)loglevel;
@end
