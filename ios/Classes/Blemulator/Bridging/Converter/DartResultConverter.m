#import "DartResultConverter.h"
#import "DartResultKeys.h"

@implementation DartResultConverter

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral {
    NSArray *resultArray = (NSArray *)result;
    NSMutableArray<Service *> *services = [[NSMutableArray alloc] init];
    NSDictionary<NSString *, NSArray<Characteristic *> *> *characteristicsResult = [[NSMutableDictionary alloc] init];
    for (NSDictionary *serviceDictionary in resultArray) {
        Service *service = [[Service alloc] initWithObjectId:(int)[serviceDictionary objectForKey:DART_RESULT_SERVICE_ID]
                                                        uuid:[CBUUID UUIDWithString:[serviceDictionary objectForKey:DART_RESULT_SERVICE_UUID]]
                                                  peripheral:peripheral
                                                   isPrimary:true];
        [services addObject:service];
        NSArray *characteristics = [serviceDictionary objectForKey:DART_RESULT_CHARACTERISTICS];
        for (NSDictionary *characteristicDictionary in characteristics) {
            Characteristic *characteristic = [[Characteristic alloc] initWithObjectId:(int)[characteristicDictionary objectForKey:DART_RESULT_CHARACTERISTIC_ID]
                                                                                 uuid:[characteristicDictionary objectForKey:DART_RESULT_CHARACTERISTIC_UUID]
                                                                                value:[characteristicDictionary objectForKey:DART_RESULT_VALUE]
                                                                              service:service
                                                                          isNotifying:[characteristicDictionary objectForKey:DART_RESULT_IS_NOTIFYING]];
        }
    }
    return [[DeviceContainer alloc] initWithIdentifier:peripheral.identifier
                                                  name:peripheral.name
                                              services:services
                                       characteristics:characteristicsResult];
}

@end
