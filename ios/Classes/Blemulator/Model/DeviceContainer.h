@interface DeviceContainer : NSObject

@property (readonly) NSString *identifier;
@property (readonly) NSString *name;
@property BOOL isConnected;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end
