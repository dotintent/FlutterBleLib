#import "BleError.h"
#import "JSONStringifier.h"

@implementation BleError

+ (void)callReject:(Reject)reject
     withErrorCode:(BleErrorCode)code
            reason:(NSString *)reason {
    [[[BleError alloc] initWithErrorCode:code reason:reason] callReject:reject];
}

- (instancetype)initWithErrorCode:(BleErrorCode)errorCode reason:(NSString *)reason {
    self = [super init];
    if (self) {
        self.errorCode = errorCode;
        self.reason = reason;

        self.attErrorCode = nil;
        self.iosErrorCode = nil;
        self.deviceID = nil;
        self.serviceUUID = nil;
        self.serviceUUID = nil;
        self.characteristicUUID = nil;
        self.descriptorUUID = nil;
        self.internalMessage = nil;
    }
    return self;
}

- (NSDictionary *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:_errorCode], @"errorCode",
            [self valueOrNull:_attErrorCode], @"attErrorCode",
            [self valueOrNull:_iosErrorCode], @"iosErrorCode",
            [NSNull null], @"androidErrorCode",
            [self valueOrNull:_reason], @"reason",
            [self valueOrNull:_deviceID], @"deviceID",
            [self valueOrNull:_serviceUUID], @"serviceUUID",
            [self valueOrNull:_characteristicUUID], @"characteristicUUID",
            [self valueOrNull:_descriptorUUID], @"descriptorUUID",
            [self valueOrNull:_internalMessage], @"internalMessage",
            nil];
}

- (void)callReject:(Reject)reject {
    reject(nil, [JSONStringifier jsonStringFromJSONObject:[self jsonObjectRepresentation]], nil);
}

- (id)valueOrNull:(id)argument {
    return argument ? argument : [NSNull null];
}

@end
