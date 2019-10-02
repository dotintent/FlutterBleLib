#import <Flutter/Flutter.h>
#import "BleError.h"

@interface FlutterErrorFactory : NSObject

+ (FlutterError *)flutterErrorForJSONString:(NSString *)jsonString;

+ (FlutterError *)flutterErrorForBleError:(BleError *)bleError;

@end
