#import "DartResultConverter.h"
#import "SimulationArgumentName.h"

@implementation DartResultConverter

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral {
    NSArray *resultArray = (NSArray *)result;
    NSMutableArray<Service *> *services = [[NSMutableArray alloc] init];
    NSDictionary<NSString *, NSArray<Characteristic *> *> *characteristicsResult = [[NSMutableDictionary alloc] init];
    for (NSDictionary *serviceDictionary in resultArray) {
        Service *service = [[Service alloc] initWithObjectId:(uint)[serviceDictionary objectForKey:SIMULATION_ARGUMENT_NAME_SERVICE_ID]
                                                        uuid:[CBUUID UUIDWithString:[serviceDictionary objectForKey:SIMULATION_ARGUMENT_NAME_SERVICE_UUID]]
                                                  peripheral:peripheral
                                                   isPrimary:true];
        [services addObject:service];
        NSArray *characteristics = [serviceDictionary objectForKey:SIMULATION_ARGUMENT_NAME_CHARACTERISTICS];
        for (NSDictionary *characteristicDictionary in characteristics) {
            Characteristic *characteristic = [[Characteristic alloc] initWithObjectId:[characteristicDictionary objectForKey:@"characteristicId"]
                                                                                 uuid:[characteristicDictionary objectForKey:@"characteristicUuid"]
                                                                                value:[characteristicDictionary objectForKey:@"value"]
                                                                              service:service
                                                                          isNotifying:[characteristicDictionary objectForKey:@"isNotifying"]];
        }
    }
    return [[DeviceContainer alloc] initWithIdentifier:peripheral.identifier
                                                  name:peripheral.name
                                              services:services
                                       characteristics:characteristicsResult];
}

@end
