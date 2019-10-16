#import "Characteristic.h"
#import "CharacteristicResponse.h"

@implementation Characteristic

- (instancetype)initWithObjectId:(int)objectId
                            uuid:(CBUUID *)uuid
                           value:(NSData *)value
                         service:(Service *)service
                     isNotifying:(BOOL)isNotifying {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.uuid = uuid;
        self.value = value;
        self.service = service;
        self.isNotifying = isNotifying;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:_objectId], CHARACTERISTIC_RESPONSE_ID,
            [_uuid UUIDString], CHARACTERISTIC_RESPONSE_UUID,
            [NSNumber numberWithInt:_service.objectId], CHARACTERISTIC_RESPONSE_SERVICE_ID,
            [_service.uuid UUIDString], CHARACTERISTIC_RESPONSE_SERVICE_UUID,
            _service.peripheral.identifier, CHARACTERISTIC_RESPONSE_DEVICE_ID,
            false, CHARACTERISTIC_RESPONSE_IS_READABLE,
            false, CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITH_RESPONSE,
            false, CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITHOUT_RESPONSE,
            false, CHARACTERISTIC_RESPONSE_IS_NOTIFIABLE,
            _isNotifying, CHARACTERISTIC_RESPONSE_IS_NOTIFYING,
            false, CHARACTERISTIC_RESPONSE_IS_INDICATABLE,
            [NSNull null], CHARACTERISTIC_RESPONSE_VALUE,
            nil];
}

@end
