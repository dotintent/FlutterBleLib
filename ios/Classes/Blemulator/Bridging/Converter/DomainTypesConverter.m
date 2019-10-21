#import "DomainTypesConverter.h"
#import "DartResultKeys.h"

@implementation DomainTypesConverter

+ (Service *)serviceFromDictionary:(NSDictionary *)dictionary {
    return [[Service alloc] initWithObjectId:[[dictionary objectForKey:DART_RESULT_SERVICE_ID] intValue]
                                        uuid:[CBUUID UUIDWithString:[dictionary objectForKey:DART_RESULT_SERVICE_UUID]]
                        peripheralIdentifier:[dictionary objectForKey:DART_RESULT_DEVICE_IDENTIFIER]
                                   isPrimary:true];
}

+ (Characteristic *)characteristicFromDictionary:(NSDictionary *)dictionary service:(Service *)service {
    id value = [dictionary objectForKey:DART_RESULT_VALUE] != [NSNull null] ?
    (NSData *)[dictionary objectForKey:DART_RESULT_VALUE] : nil;
    return [[Characteristic alloc] initWithObjectId:[[dictionary objectForKey:DART_RESULT_CHARACTERISTIC_ID] intValue]
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
