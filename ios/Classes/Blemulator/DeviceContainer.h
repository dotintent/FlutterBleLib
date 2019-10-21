#import "Service.h"
#import "Characteristic.h"

@interface DeviceContainer : NSObject

@property (readonly) NSString *identifier;
@property (readonly) NSString *name;
@property (readonly) NSArray<Service *> *services;
@property (readonly) NSDictionary<NSString *, NSArray<Characteristic *> *> *characteristics;
@property BOOL isConnected;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                          services:(NSArray<Service *> *)services
                   characteristics:(NSDictionary<NSString *, NSArray<Characteristic *> *> *)characteristics;

- (NSArray *)servicesJsonRepresentation;

- (NSArray *)characteristicsJsonRepresentationForService:(NSString *)serviceUuidString;

@end
