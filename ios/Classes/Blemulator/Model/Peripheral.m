#import "Peripheral.h"
#import "PeripheralResponse.h"

@implementation Peripheral

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                               mtu:(NSInteger)mtu {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.mtu = mtu;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _identifier, PERIPHERAL_RESPONSE_ID,
            _name, PERIPHERAL_RESPONSE_NAME,
            [NSNull null], PERIPHERAL_RESPONSE_RSSI,
            [NSNumber numberWithInt:_mtu], PERIPHERAL_RESPONSE_MTU,
            [NSNull null], PERIPHERAL_RESPONSE_MANUFACTURER_DATA,
            [NSNull null], PERIPHERAL_RESPONSE_SERVICE_DATA,
            [NSNull null], PERIPHERAL_RESPONSE_SERVICE_UUIDS,
            [NSNull null], PERIPHERAL_RESPONSE_LOCAL_NAME,
            [NSNull null], PERIPHERAL_RESPONSE_TX_POWER_LEVEL,
            [NSNull null], PERIPHERAL_RESPONSE_SOLICITED_SERVICE_UUIDS,
            [NSNull null], PERIPHERAL_RESPONSE_IS_CONNECTABLE,
            [NSNull null], PERIPHERAL_RESPONSE_OVERFLOW_SERVICE_UUIDS,
            nil];
}

@end
