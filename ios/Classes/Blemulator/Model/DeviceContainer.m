#import "DeviceContainer.h"

@interface DeviceContainer ()

@property (readwrite) NSString *identifier;
@property (readwrite) NSString *name;
@property (readwrite) NSArray<Service *> *services;
@property (readwrite) NSDictionary<NSString *, NSArray<Characteristic *> *> *characteristics;

@end

@implementation DeviceContainer

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.services = nil;
        self.characteristics = nil;
        self.isConnected = false;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                          services:(NSArray<Service *> *)services
                   characteristics:(NSDictionary<NSString *, NSArray<Characteristic *> *> *)characteristics {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.services = services;
        self.characteristics = characteristics;
        self.isConnected = false;
    }
    return self;
}

- (NSArray *)servicesJsonRepresentation {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (Service *service in _services) {
        [result addObject:[service jsonObjectRepresentation]];
    }
    return result;
}

@end
