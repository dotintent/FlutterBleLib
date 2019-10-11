@interface Peripheral : NSObject

@property NSUUID * _Nonnull identifier;
@property NSString * _Nullable name;
@property NSInteger mtu;

- (instancetype _Nonnull)initWithIdentifier:(NSUUID * _Nonnull)identifier
                                       name:(NSString * _Nullable)name
                                        mtu:(NSInteger)mtu;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
