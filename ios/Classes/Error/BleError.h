@interface BleError : NSObject

@property NSNumber *errorCode;
@property NSNumber *attErrorCode;
@property NSNumber *iosErrorCode;
@property NSString *reason;
@property NSString *deviceID;
@property NSString *serviceUUID;
@property NSString *characteristicUUID;
@property NSString *descriptorUUID;
@property NSString *internalMessage;

- (instancetype)initWithErrorCode:(NSNumber *)errorCode reason:(NSString *)reason;

- (NSDictionary *)dictionaryRepresentation;

@end
