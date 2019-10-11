#import "ScannedPeripheral.h"

@implementation ScannedPeripheral

- (instancetype)initWithPeripheral:(Peripheral *)peripheral
                 advertisementData:(AdvertisementData *)advertisementData
                              rssi:(NSNumber *)rssi {
    self = [super init];
    if (self) {
        self.peripheral = peripheral;
        self.advertisementData = advertisementData;
        self.rssi = rssi;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"",
            nil];
}

@end
