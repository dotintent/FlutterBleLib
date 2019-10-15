typedef enum { connecting, connected, disconnected } ConnectionState;

@interface ConnectionStateEvent : NSObject

@property NSString * _Nonnull deviceId;
@property NSString * _Nonnull connectionState;

- (instancetype _Nonnull)initWith:(NSString * _Nonnull)deviceId
                  connectionState:(NSString * _Nonnull)connectionState;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
