#import "DartResultConverter.h"
#import "DartResultKeys.h"

@implementation DartResultConverter

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral {
    NSArray *resultArray = (NSArray *)result;

    NSMutableArray<Service *> *services = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSString *, NSArray<Characteristic *> *> *characteristics = [[NSMutableDictionary alloc] init];

    for (NSDictionary *serviceDictionary in resultArray) {
        Service *service = [[Service alloc] initWithObjectId:(int)[serviceDictionary objectForKey:DART_RESULT_SERVICE_ID]
                                                        uuid:[CBUUID UUIDWithString:[serviceDictionary objectForKey:DART_RESULT_SERVICE_UUID]]
                                                  peripheral:peripheral
                                                   isPrimary:true];

        NSMutableArray *characteristicsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *characteristicDictionary in [serviceDictionary objectForKey:DART_RESULT_CHARACTERISTICS]) {
            Characteristic *characteristic = [[Characteristic alloc] initWithObjectId:(int)[characteristicDictionary objectForKey:DART_RESULT_CHARACTERISTIC_ID]
                                                                                 uuid:[CBUUID UUIDWithString:[characteristicDictionary objectForKey:DART_RESULT_CHARACTERISTIC_UUID]]
                                                                                value:[characteristicDictionary objectForKey:DART_RESULT_VALUE]
                                                                              service:service
                                                                          isNotifying:[[characteristicDictionary objectForKey:DART_RESULT_IS_NOTIFYING] boolValue]
                                                                           properties:[self calculatePropertiesFor:characteristicDictionary]];
            [characteristicsArray addObject:characteristic];
        }

        [services addObject:service];
        [characteristics setObject:characteristicsArray forKey:[service.uuid UUIDString]];
    }

    return [[DeviceContainer alloc] initWithIdentifier:peripheral.identifier
                                                  name:peripheral.name
                                              services:services
                                       characteristics:characteristics];
}

+ (CBCharacteristicProperties)calculatePropertiesFor:(NSDictionary *)characteristicDictionary {
    CBCharacteristicProperties properties = 0;

    BOOL isReadable = [[characteristicDictionary objectForKey:DART_RESULT_IS_READABLE] boolValue];
    BOOL isWritableWithResponse = [[characteristicDictionary objectForKey:DART_RESULT_IS_WRITABLE_WITH_RESPONSE] boolValue];
    BOOL isWritableWithoutResponse = [[characteristicDictionary objectForKey:DART_RESULT_IS_WRITABLE_WITHOUT_RESPONSE] boolValue];
    BOOL isNotifiable = [[characteristicDictionary objectForKey:DART_RESULT_IS_NOTIFIABLE] boolValue];
    BOOL isIndicatable = [[characteristicDictionary objectForKey:DART_RESULT_IS_INDICATABLE] boolValue];

    if (isReadable) { properties |= CBCharacteristicPropertyRead; }
    if (isWritableWithResponse) { properties |= CBCharacteristicPropertyWrite; }
    if (isWritableWithoutResponse) { properties |= CBCharacteristicPropertyWriteWithoutResponse; }
    if (isNotifiable) { properties |= CBCharacteristicPropertyNotify; }
    if (isIndicatable) { properties |= CBCharacteristicPropertyIndicate; }

    return properties;
}

@end
