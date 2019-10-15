#import "AdvertisementData.h"

@implementation AdvertisementData

- (instancetype)initWithManufacturerData:(NSData *)manufacturerData
                             serviceData:(NSDictionary<CBUUID *,NSData *> *)serviceData
                            serviceUUIDs:(NSArray<CBUUID *> *)serviceUUIDs
                               localName:(NSString *)localName
                            txPowerLevel:(NSNumber *)txPowerLevel
                   solicitedServiceUUIDs:(NSArray<CBUUID *> *)solicitedServiceUUIDs
                           isConnectable:(BOOL *)isConnectable
                    overflowServiceUUIDs:(NSArray<CBUUID *> *)overflowServiceUUIDs {
    self = [super init];
    if (self) {
        self.manufacturerData = manufacturerData;
        self.serviceData = serviceData;
        self.serviceUUIDs = serviceUUIDs;
        self.localName = localName;
        self.txPowerLevel = txPowerLevel;
        self.solicitedServiceUUIDs = solicitedServiceUUIDs;
        self.isConnectable = isConnectable;
        self.overflowServiceUUIDs = overflowServiceUUIDs;
    }
    return self;
}

@end
