#import "Characteristic.h"
#import "CharacteristicResponse.h"

@implementation Characteristic

- (instancetype)initWithObjectId:(int)objectId
                            uuid:(CBUUID *)uuid
                           value:(NSData *)value
                         service:(Service *)service
                     isNotifying:(BOOL)isNotifying
                      properties:(CBCharacteristicProperties)properties {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.uuid = uuid;
        self.value = value;
        self.service = service;
        self.isNotifying = isNotifying;
        self.properties = properties;
        NSLog(@"%@", [NSNumber numberWithBool:isNotifying]);
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
            [NSNumber numberWithBool:_properties & CBCharacteristicPropertyRead], CHARACTERISTIC_RESPONSE_IS_READABLE,
            [NSNumber numberWithBool:_properties & CBCharacteristicPropertyWrite], CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITH_RESPONSE,
            [NSNumber numberWithBool:_properties & CBCharacteristicPropertyWriteWithoutResponse], CHARACTERISTIC_RESPONSE_IS_WRITABLE_WITHOUT_RESPONSE,
            [NSNumber numberWithBool:_properties & CBCharacteristicPropertyNotify], CHARACTERISTIC_RESPONSE_IS_NOTIFIABLE,
            [NSNumber numberWithBool:_isNotifying], CHARACTERISTIC_RESPONSE_IS_NOTIFYING,
            [NSNumber numberWithBool:_properties & CBCharacteristicPropertyIndicate], CHARACTERISTIC_RESPONSE_IS_INDICATABLE,
            [NSNull null], CHARACTERISTIC_RESPONSE_VALUE,
            nil];
}

@end
