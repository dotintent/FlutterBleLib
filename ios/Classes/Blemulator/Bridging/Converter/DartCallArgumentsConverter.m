#import "DartCallArgumentsConverter.h"
#import "DomainTypesConverter.h"
#import "DartCallArgumentKeys.h"
#import "ArrayUtilities.h"

@implementation DartCallArgumentsConverter

+ (ScannedPeripheral *)scannedPeripheralFromCallArguments:(NSDictionary<NSString *,id> *)callArguments {
    Peripheral *peripheral = [[Peripheral alloc] initWithIdentifier:[callArguments objectForKey:DART_CALL_ARGUMENT_PERIPHERAL_ID]
                                                               name:[callArguments objectForKey:DART_CALL_ARGUMENT_NAME]];

    id serviceUUIDs = [NSNull null];
    id solicitedServiceUUIDs = [NSNull null];
    id overflowServiceUUIDs = [NSNull null];

    if ([callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_UUIDS] != [NSNull null]) {
        serviceUUIDs = [ArrayUtilities cbuuidArrayFromStringArray:[callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_UUIDS]];
    }
    if ([callArguments objectForKey:DART_CALL_ARGUMENT_SOLICITED_SERVICE_UUIDS] != [NSNull null]) {
        solicitedServiceUUIDs = [ArrayUtilities cbuuidArrayFromStringArray:[callArguments objectForKey:DART_CALL_ARGUMENT_SOLICITED_SERVICE_UUIDS]];
    }
    if ([callArguments objectForKey:DART_CALL_ARGUMENT_OVERFLOW_UUIDS] != [NSNull null]) {
        overflowServiceUUIDs = [ArrayUtilities cbuuidArrayFromStringArray:[callArguments objectForKey:DART_CALL_ARGUMENT_OVERFLOW_UUIDS]];
    }

    AdvertisementData *advertisementData =
    [[AdvertisementData alloc] initWithManufacturerData:[callArguments objectForKey:DART_CALL_ARGUMENT_MANUFACTURER_DATA]
                                            serviceData:[callArguments objectForKey:DART_CALL_ARGUMENT_SERVICE_DATA]
                                           serviceUUIDs:serviceUUIDs
                                              localName:[callArguments objectForKey:DART_CALL_ARGUMENT_LOCAL_NAME]
                                           txPowerLevel:[callArguments objectForKey:DART_CALL_ARGUMENT_TX_POWER_LEVEL]
                                  solicitedServiceUUIDs:solicitedServiceUUIDs
                                          isConnectable:[[callArguments objectForKey:DART_CALL_ARGUMENT_IS_CONNECTABLE] boolValue]
                                   overflowServiceUUIDs:overflowServiceUUIDs];

    return [[ScannedPeripheral alloc] initWithPeripheral:peripheral
                                       advertisementData:advertisementData
                                                    rssi:[callArguments objectForKey:DART_CALL_ARGUMENT_RSSI]];
}

+ (ConnectionStateEvent *)connectionStateEventFromCallArguments:(NSDictionary<NSString *,id> *)callArguments {
    return [[ConnectionStateEvent alloc] initWith:[callArguments objectForKey:DART_CALL_ARGUMENT_PERIPHERAL_ID]
                                  connectionState:[callArguments objectForKey:DART_CALL_CONNECTION_STATE]];
}

+ (Characteristic *)characteristicFromCallArguments:(NSDictionary<NSString *,id> *)callArguments {
    return [DomainTypesConverter characteristicFromDictionary:callArguments
                                                      service:[DomainTypesConverter serviceFromDictionary:callArguments]];
}

@end
