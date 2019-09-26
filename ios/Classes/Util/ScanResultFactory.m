#import "ScanResultFactory.h"

@implementation ScanResultFactory

+ (NSString *)scanResultFromJSONObject:(id)jsonObject {
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
