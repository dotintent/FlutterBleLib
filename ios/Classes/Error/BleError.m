#import "BleError.h"

@implementation BleError

- (instancetype)initWithErrorCode:(NSNumber *)errorCode reason:(NSString *)reason {
    self = [super init];
    if (self) {
        self.errorCode = errorCode;
        self.reason = reason;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.errorCode, @"errorCode",
            self.attErrorCode, @"attErrorCode",
            self.iosErrorCode, @"iosErrorCode",
            nil, @"androidErrorCode",
            self.reason, @"reason",
            self.deviceID, @"deviceID",
            self.serviceUUID, @"serviceUUID",
            self.characteristicUUID, @"characteristicUUID",
            self.descriptorUUID, @"descriptorUUID",
            self.internalMessage, @"internalMessage",
            nil];
}

@end
