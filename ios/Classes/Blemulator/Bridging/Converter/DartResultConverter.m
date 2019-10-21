#import "DartResultConverter.h"
#import "DomainTypesConverter.h"
#import "DartResultKeys.h"

@implementation DartResultConverter

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral {
    NSArray *resultArray = (NSArray *)result;

    NSMutableArray<Service *> *services = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSString *, NSArray<Characteristic *> *> *characteristics = [[NSMutableDictionary alloc] init];

    for (NSDictionary *serviceDictionary in resultArray) {
        Service *service = [DomainTypesConverter serviceFromDictionary:serviceDictionary];

        NSMutableArray *characteristicsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *characteristicDictionary in [serviceDictionary objectForKey:DART_RESULT_CHARACTERISTICS]) {
            Characteristic *characteristic = [DomainTypesConverter characteristicFromDictionary:characteristicDictionary service:service];
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
    return [DomainTypesConverter characteristicFromDictionary:resultDictionary
                                      service:[DomainTypesConverter serviceFromDictionary:resultDictionary]];
}

@end
