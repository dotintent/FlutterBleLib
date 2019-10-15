#import "StringUtilities.h"

@implementation StringUtilitites

+ (NSString *)stringFromNSUUID:(NSUUID *)nsuuid {
    return [nsuuid UUIDString];
}

+ (NSUUID *)nsuuidFromString:(NSString *)string {
    return [[NSUUID alloc] initWithUUIDString:string];
}

@end
