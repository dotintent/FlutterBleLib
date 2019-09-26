#import "ArgumentValidator.h"

@implementation ArgumentValidator

+ (nullable id)validArgumentOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null]) {
        return argument;
    } else {
        return nil;
    }
}

+ (nullable NSString*)validStringOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null] && [argument isKindOfClass:[NSString class]]) {
        return (NSString*)argument;
    } else {
        return nil;
    }
}

+ (nullable NSArray<NSString*>*)validStringArrayOrNil:(id)argument {
    if (argument != nil && (NSNull *)argument != [NSNull null] && [argument isKindOfClass:[NSArray<NSString *> class]]) {
        return (NSArray<NSString*>*)argument;
    } else {
        return nil;
    }
}

+ (nullable NSDictionary<NSString*, id>*)validDictionaryOrNil:(NSArray<NSString*>*)argumentKeys in:(NSDictionary<NSString*, id>*)dictionary {
    NSMutableDictionary<NSString*, id>* resultDictionary = [NSMutableDictionary new];
    for (NSString *argumentKey in argumentKeys) {
        if ([dictionary objectForKey:argumentKey] != nil) {
            [resultDictionary setValue:[self validArgumentOrNil:[dictionary objectForKey:argumentKey]] forKey:argumentKey];
        }
    }
    return resultDictionary;
}

@end
