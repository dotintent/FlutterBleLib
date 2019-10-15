@interface Peripheral : NSObject

@property NSString * _Nonnull identifier;
@property NSString * _Nullable name;
@property NSInteger mtu;

- (instancetype _Nonnull)initWithIdentifier:(NSString * _Nonnull)identifier
                                       name:(NSString * _Nullable)name
                                        mtu:(NSInteger)mtu;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
