@interface DeviceContainer : NSObject

@property (readonly) NSString *identifier;
@property (readonly) NSString *name;

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name;

@end
