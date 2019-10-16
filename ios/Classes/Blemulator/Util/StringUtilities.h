@interface StringUtilitites : NSObject

+ (NSString *)stringFromNSUUID:(NSUUID *)nsuuid;

+ (NSUUID *)nsuuidFromString:(NSString *)string;

@end
