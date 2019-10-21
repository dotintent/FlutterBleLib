#import "Service.h"
#import "Characteristic.h"

@interface DomainTypesConverter: NSObject

+ (Service *)serviceFromDictionary:(NSDictionary *)dictionary;

+ (Characteristic *)characteristicFromDictionary:(NSDictionary *)dictionary service:(Service *)service;

@end
