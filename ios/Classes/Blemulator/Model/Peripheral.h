@interface Peripheral : NSObject

@property NSString * _Nonnull identifier;
@property NSString * _Nullable name;

- (instancetype _Nonnull)initWithIdentifier:(NSString * _Nonnull)identifier
                                       name:(NSString * _Nullable)name;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

- (NSInteger)mtu;

@end
