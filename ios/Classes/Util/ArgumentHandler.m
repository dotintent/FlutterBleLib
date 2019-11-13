#import "ArgumentHandler.h"

@implementation ArgumentHandler

+ (nullable id)argumentOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null]) {
        return argument;
    } else {
        return nil;
    }
}

+ (nullable NSString *)stringOrNil:(id)argument {
    if (argument != nil && [argument isKindOfClass:[NSString class]]) {
        return (NSString*)argument;
    } else {
        return nil;
    }
}

+ (nullable NSArray<NSString *> *)stringArrayOrNil:(id)argument {
    if (argument != nil && [argument isKindOfClass:[NSArray<NSString *> class]]) {
        return (NSArray<NSString*>*)argument;
    } else {
        return nil;
    }
}

+ (nullable NSDictionary<NSString *, id> *)dictionaryOrNil:(NSArray<NSString *> *)argumentKeys in:(NSDictionary<NSString *, id> *)dictionary {
    NSMutableDictionary<NSString *, id> * resultDictionary = [NSMutableDictionary new];
    for (NSString *argumentKey in argumentKeys) {
        if ([dictionary objectForKey:argumentKey] != nil) {
            [resultDictionary setValue:[self argumentOrNil:[dictionary objectForKey:argumentKey]] forKey:argumentKey];
        }
    }
    return resultDictionary;
}

@end
