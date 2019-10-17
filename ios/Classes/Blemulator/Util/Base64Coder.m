#import "Base64Coder.h"

@implementation Base64Coder

+ (NSString *)base64StringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

@end
