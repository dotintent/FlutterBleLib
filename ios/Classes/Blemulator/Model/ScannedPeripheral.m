#import "ScannedPeripheral.h"
#import "PeripheralResponse.h"
#import "Base64Coder.h"

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
    id manufacturerData = [NSNull null];
    id serviceUUIDs = [NSNull null];
    id solicitedServiceUUIDs = [NSNull null];
    id overflowServiceUUIDs = [NSNull null];

    if (![_advertisementData.manufacturerData isKindOfClass: NSNull.class]) {
        manufacturerData = [Base64Coder base64StringFromData:_advertisementData.manufacturerData];
    }
    if (![_advertisementData.serviceUUIDs isKindOfClass: NSNull.class]) {
        serviceUUIDs = [[NSMutableArray alloc] init];
        for (CBUUID *serviceUUID in _advertisementData.serviceUUIDs) {
            [serviceUUIDs addObject:[serviceUUID UUIDString]];
        }
    }
    if (![_advertisementData.solicitedServiceUUIDs isKindOfClass: NSNull.class]) {
        solicitedServiceUUIDs = [[NSMutableArray alloc] init];
        for (CBUUID *solicitedDerviceUUID in _advertisementData.serviceUUIDs) {
            [solicitedServiceUUIDs addObject:[solicitedDerviceUUID UUIDString]];
        }
    }
    if (![_advertisementData.overflowServiceUUIDs isKindOfClass: NSNull.class]) {
        overflowServiceUUIDs = [[NSMutableArray alloc] init];
        for (CBUUID *overflowServiceUUID in _advertisementData.serviceUUIDs) {
            [overflowServiceUUIDs addObject:[overflowServiceUUID UUIDString]];
        }
    }

    return [NSDictionary dictionaryWithObjectsAndKeys:
            [_peripheral.identifier UUIDString], PERIPHERAL_RESPONSE_ID,
            _peripheral.name, PERIPHERAL_RESPONSE_NAME,
            _rssi, PERIPHERAL_RESPONSE_RSSI,
            _peripheral.mtu, PERIPHERAL_RESPONSE_MTU,
            manufacturerData, PERIPHERAL_RESPONSE_MANUFACTURER_DATA,
            _advertisementData.serviceData, PERIPHERAL_RESPONSE_SERVICE_DATA,
            serviceUUIDs, PERIPHERAL_RESPONSE_SERVICE_UUIDS,
            _advertisementData.localName, PERIPHERAL_RESPONSE_LOCAL_NAME,
            _advertisementData.txPowerLevel, PERIPHERAL_RESPONSE_TX_POWER_LEVEL,
            solicitedServiceUUIDs, PERIPHERAL_RESPONSE_SOLICITED_SERVICE_UUIDS,
            [NSNumber numberWithBool:_advertisementData.isConnectable], PERIPHERAL_RESPONSE_IS_CONNECTABLE,
            overflowServiceUUIDs, PERIPHERAL_RESPONSE_OVERFLOW_SERVICE_UUIDS,
            nil];
}

@end
