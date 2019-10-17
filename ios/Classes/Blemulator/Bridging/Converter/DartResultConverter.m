#import "DartResultConverter.h"
#import "DartResultKeys.h"

@implementation DartResultConverter

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral {
    NSArray *resultArray = (NSArray *)result;

    NSMutableArray<Service *> *services = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSString *, NSArray<Characteristic *> *> *characteristics = [[NSMutableDictionary alloc] init];

    for (NSDictionary *serviceDictionary in resultArray) {
        Service *service = [self serviceFromDictionary:serviceDictionary peripheral:peripheral];

        NSMutableArray *characteristicsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *characteristicDictionary in [serviceDictionary objectForKey:DART_RESULT_CHARACTERISTICS]) {
            Characteristic *characteristic = [self characteristicFromDictionary:characteristicDictionary service:service];
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

+ (Characteristic *)characteristicFromDartResult:(id)result {
    NSDictionary *resultDictionary = (NSDictionary *)result;
    return [self characteristicFromDictionary:resultDictionary
                                      service:[self serviceFromDictionary:resultDictionary
                                                               peripheral:[self peripheralFromDictionary:resultDictionary]]];
}

+ (Peripheral *)peripheralFromDictionary:(NSDictionary *)dictionary {
    return [[Peripheral alloc] initWithIdentifier:[dictionary objectForKey:DART_RESULT_DEVICE_IDENTIFIER]
                                             name:nil
                                              mtu:23];
}

+ (Service *)serviceFromDictionary:(NSDictionary *)dictionary peripheral:(Peripheral *)peripheral {
    return [[Service alloc] initWithObjectId:[[dictionary objectForKey:DART_RESULT_SERVICE_ID] integerValue]
                                        uuid:[CBUUID UUIDWithString:[dictionary objectForKey:DART_RESULT_SERVICE_UUID]]
                                  peripheral:peripheral
                                   isPrimary:true];
}

+ (Characteristic *)characteristicFromDictionary:(NSDictionary *)dictionary service:(Service *)service {
    id value = [dictionary objectForKey:DART_RESULT_VALUE] != [NSNull null] ?
                (NSData *)[dictionary objectForKey:DART_RESULT_VALUE] : nil;
    return [[Characteristic alloc] initWithObjectId:[[dictionary objectForKey:DART_RESULT_CHARACTERISTIC_ID] integerValue]
                                               uuid:[CBUUID UUIDWithString:[dictionary objectForKey:DART_RESULT_CHARACTERISTIC_UUID]]
                                              value:value
                                            service:service
                                        isNotifying:[[dictionary objectForKey:DART_RESULT_IS_NOTIFYING] boolValue]
                                         properties:[self calculatePropertiesFor:dictionary]];
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
