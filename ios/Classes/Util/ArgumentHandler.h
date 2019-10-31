@interface ArgumentHandler : NSObject

+ (nullable id)argumentOrNil:(id _Nonnull)argument;

+ (nullable NSString *)stringOrNil:(id _Nonnull)argument;

+ (nullable NSArray<NSString *> *)stringArrayOrNil:(id _Nonnull)argument;

+ (nullable NSDictionary<NSString *, id> *)dictionaryOrNil:(NSArray<NSString *> * _Nonnull)argumentKeys in:(NSDictionary<NSString *, id> * _Nonnull)dictionary;

@end
