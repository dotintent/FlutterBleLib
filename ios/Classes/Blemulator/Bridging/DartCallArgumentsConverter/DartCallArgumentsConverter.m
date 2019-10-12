#import "DartCallArgumentsConverter.h"
#import "DartCallArgumentKeys.h"

@implementation DartCallArgumentsConverter

+ (ScannedPeripheral *)scannedPeripheralFromCallArguments:(NSDictionary<NSString *,id> *)callArguments {
    NSLog(@"%@", [[NSUUID alloc] initWithUUIDString:[callArguments objectForKey:DART_CALL_ARGUMENT_PERIPHERAL_ID]]);
    Peripheral *peripheral = [[Peripheral alloc] initWithIdentifier:[[NSUUID alloc] initWithUUIDString:[callArguments objectForKey:DART_CALL_ARGUMENT_PERIPHERAL_ID]]
                                                               name:[callArguments objectForKey:DART_CALL_ARGUMENT_NAME]
                                                                mtu:(NSInteger)[callArguments objectForKey:DART_CALL_ARGUMENT_MTU]];

    id serviceUUIDs = [NSNull null];
    id solicitedServiceUUIDs = [NSNull null];
    id overflowServiceUUIDs = [NSNull null];

    if ([callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_UUIDS] != [NSNull null]) {
        serviceUUIDs = [[NSMutableArray alloc] init];
        for (NSString * serviceUUIDString in [callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_UUIDS]) {
            [serviceUUIDs addObject:[CBUUID UUIDWithString:serviceUUIDString]];
        }
    }
    if ([callArguments objectForKey:DART_CALL_ARGUMENT_SOLICITED_SERVICE_UUIDS] != [NSNull null]) {
        solicitedServiceUUIDs = [[NSMutableArray alloc] init];
        for (NSString * serviceUUIDString in [callArguments objectForKey:DART_CALL_ARGUMENT_SOLICITED_SERVICE_UUIDS]) {
            [solicitedServiceUUIDs addObject:[CBUUID UUIDWithString:serviceUUIDString]];
        }
    }
    if ([callArguments objectForKey:DART_CALL_ARGUMENT_OVERFLOW_UUIDS] != [NSNull null]) {
        overflowServiceUUIDs = [[NSMutableArray alloc] init];
        for (NSString * serviceUUIDString in [callArguments objectForKey:DART_CALL_ARGUMENT_OVERFLOW_UUIDS]) {
            [overflowServiceUUIDs addObject:[CBUUID UUIDWithString:serviceUUIDString]];
        }
    }

    NSLog(@"%@", serviceUUIDs);
    NSLog(@"%@", [serviceUUIDs class]);
    NSLog(@"%@", solicitedServiceUUIDs);
    NSLog(@"%@", [solicitedServiceUUIDs class]);
    NSLog(@"%@", overflowServiceUUIDs);
    NSLog(@"%@", [overflowServiceUUIDs class]);

    AdvertisementData *advertisementData =
    [[AdvertisementData alloc] initWithManufacturerData:[callArguments objectForKey:DART_CALL_ARGUMENT_MANUFACTURER_DATA]
                                            serviceData:[callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_DATA]
                                           serviceUUIDs:serviceUUIDs
                                              localName:[callArguments objectForKey:DART_CALL_ARGUMENT_LOCAL_NAME]
                                           txPowerLevel:[callArguments objectForKey:DART_CALL_ARGUMENT_TX_POWER_LEVEL]
                                  solicitedServiceUUIDs:solicitedServiceUUIDs
                                          isConnectable:(BOOL)[callArguments objectForKey:DART_CALL_ARGUMENT_IS_CONNECTABLE]
                                   overflowServiceUUIDs:overflowServiceUUIDs];

    return [[ScannedPeripheral alloc] initWithPeripheral:peripheral
                                       advertisementData:advertisementData
                                                    rssi:[callArguments objectForKey:DART_CALL_ARGUMENT_RSSI]];
}

@end
