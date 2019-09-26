#import "FlutterErrorFactory.h"

@implementation FlutterErrorFactory

+ (FlutterError*)flutterErrorFromJSONString:(NSString*)jsonString {
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [FlutterError errorWithCode:[dictionary objectForKey:@"errorCode"]
                               message:[dictionary objectForKey:@"reason"]
                               details:jsonString];
}

@end
