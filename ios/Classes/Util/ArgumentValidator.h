@interface ArgumentValidator : NSObject

+ (nullable id)validArgumentOrNil:(id _Nonnull)argument;

+ (nullable NSString *)validStringOrNil:(id _Nonnull)argument;

+ (nullable NSArray<NSString *> *)validStringArrayOrNil:(id _Nonnull)argument;

+ (nullable NSDictionary<NSString *, id> *)validDictionaryOrNil:(NSArray<NSString *> * _Nonnull)argumentKeys in:(NSDictionary<NSString *, id> * _Nonnull)dictionary;

@end
