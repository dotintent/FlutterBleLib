#import "BleErrorCode.h"
#import "CommonTypes.h"

@interface BleError : NSObject

@property BleErrorCode errorCode;
@property NSNumber *attErrorCode;
@property NSNumber *iosErrorCode;
@property NSString *reason;
@property NSString *deviceID;
@property NSString *serviceUUID;
@property NSString *characteristicUUID;
@property NSString *descriptorUUID;
@property NSString *internalMessage;

- (instancetype)initWithErrorCode:(BleErrorCode)errorCode reason:(NSString *)reason;

- (NSDictionary *)jsonObjectRepresentation;

- (void)callReject:(Reject)reject;

@end
