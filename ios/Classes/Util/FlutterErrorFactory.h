#import <Flutter/Flutter.h>

@interface FlutterErrorFactory : NSObject

+ (FlutterError *)flutterErrorFromJSONString:(NSString *)jsonString;

+ (FlutterError *)flutterErrorFromJSONString:(NSString *)jsonString
                           withTransactionId:(NSString *)transactionId;

@end
