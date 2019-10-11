#import "DartCallArgumentsConverter.h"
#import "DartCallArgumentKeys.h"

@implementation DartCallArgumentsConverter

+ (ScannedPeripheral *)scannedPeripheralFromCallArguments:(NSDictionary<NSString *,id> *)callArguments {
    Peripheral *peripheral = [[Peripheral alloc] initWithIdentifier:[callArguments objectForKey:DART_CALL_ARGUMENT_PERIPHERAL_ID]
                                                               name:[callArguments objectForKey:DART_CALL_ARGUMENT_NAME]
                                                                mtu:(NSInteger)[callArguments objectForKey:DART_CALL_ARGUMENT_MTU]];
    AdvertisementData *advertisementData =
    [[AdvertisementData alloc] initWithManufacturerData:[callArguments objectForKey:DART_CALL_ARGUMENT_MANUFACTURER_DATA]
                                            serviceData:[callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_DATA]
                                           serviceUUIDs:[callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_UUIDS]
                                              localName:[callArguments objectForKey:DART_CALL_ARGUMENT_LOCAL_NAME]
                                           txPowerLevel:[callArguments objectForKey:DART_CALL_ARGUMENT_TX_POWER_LEVEL]
                                  solicitedServiceUUIDs:[callArguments objectForKey:DART_CALL_ARGUMENT_SOLICITED_SERVICE_UUIDS]
                                          isConnectable:(BOOL)[callArguments objectForKey:DART_CALL_ARGUMENT_IS_CONNECTABLE]
                                   overflowServiceUUIDs:[callArguments objectForKey:DART_CALL_ARGUMENT_OVERFLOW_UUIDS]];
    return [[ScannedPeripheral alloc] initWithPeripheral:peripheral
                                       advertisementData:advertisementData
                                                    rssi:[callArguments objectForKey:DART_CALL_ARGUMENT_RSSI]];
}

@end
