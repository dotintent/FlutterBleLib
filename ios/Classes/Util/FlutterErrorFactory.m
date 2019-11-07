#import "FlutterErrorFactory.h"
#import "JSONStringifier.h"

@implementation FlutterErrorFactory

+ (FlutterError *)flutterErrorFromJSONString:(NSString *)jsonString {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [FlutterError errorWithCode:[[dictionary objectForKey:@"errorCode"] stringValue]
                               message:[dictionary objectForKey:@"reason"]
                               details:jsonString];
}

+ (FlutterError *)flutterErrorFromJSONString:(NSString *)jsonString
                           withTransactionId:(NSString *)transactionId {
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
    [dictionary setObject:transactionId forKey:@"transactionId"];
    return [FlutterError errorWithCode:[[dictionary objectForKey:@"errorCode"] stringValue]
                               message:[dictionary objectForKey:@"reason"]
                               details:[JSONStringifier jsonStringFromJSONObject:dictionary]];
}

@end
