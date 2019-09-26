#import <Flutter/Flutter.h>

@interface FlutterErrorFactory : NSObject

+ (FlutterError*)flutterErrorFromJSONString:(NSString*)jsonString;

@end
