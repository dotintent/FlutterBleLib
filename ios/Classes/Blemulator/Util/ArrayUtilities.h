#import <CoreBluetooth/CoreBluetooth.h>

@interface ArrayUtilities : NSObject

+ (NSArray<NSString *> *)stringArrayFromCBUUIDArray:(NSArray<CBUUID *> *)cbuuidArray;

+ (NSArray<CBUUID *> *)cbuuidArrayFromStringArray:(NSArray<NSString *> *)stringArray;

@end
