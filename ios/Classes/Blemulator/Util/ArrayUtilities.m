#import "ArrayUtilities.h"

@implementation ArrayUtilities

+ (NSArray<NSString *> *)stringArrayFromCBUUIDArray:(NSArray<CBUUID *> *)cbuuidArray {
    NSMutableArray<NSString *> *stringArray = [[NSMutableArray alloc] init];
    for (CBUUID * cbuuid in cbuuidArray) {
        [stringArray addObject:[cbuuid UUIDString].lowercaseString];
    }
    return stringArray;
}

+ (NSArray<CBUUID *> *)cbuuidArrayFromStringArray:(NSArray<NSString *> *)stringArray {
    NSMutableArray<CBUUID *> *cbuuidArray = [[NSMutableArray alloc] init];
    for (NSString * cbuuidString in stringArray) {
        [cbuuidArray addObject:[CBUUID UUIDWithString:cbuuidString]];
    }
    return cbuuidArray;
}

@end
