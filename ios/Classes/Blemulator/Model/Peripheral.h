@interface Peripheral : NSObject

// TODO: - identifiers' type is problematic for now
//          because flutter is using mac address as identifier now
//          for simulation and on iOS it should be an UUID
//
//          This results in inability to create a NSUUID from such identifier sent by flutter
@property NSUUID * _Nonnull identifier;
@property NSString * _Nullable name;
@property NSInteger mtu;

- (instancetype _Nonnull)initWithIdentifier:(NSUUID * _Nonnull)identifier
                                       name:(NSString * _Nullable)name
                                        mtu:(NSInteger)mtu;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
