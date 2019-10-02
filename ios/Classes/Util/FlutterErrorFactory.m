#import "FlutterErrorFactory.h"
#import "JSONStringifier.h"

@implementation FlutterErrorFactory

+ (FlutterError *)flutterErrorForJSONString:(NSString *)jsonString {
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [FlutterError errorWithCode:[dictionary objectForKey:@"errorCode"]
                               message:[dictionary objectForKey:@"reason"]
                               details:jsonString];
}

+ (FlutterError *)flutterErrorForBleError:(BleError *)bleError {
    return [FlutterError errorWithCode:[bleError.errorCode stringValue]
                               message:bleError.reason
                               details:[JSONStringifier jsonStringFromJSONObject:[bleError dictionaryRepresentation]]];
}

@end
