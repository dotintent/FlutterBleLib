#import "Peripheral.h"

@implementation Peripheral

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                               mtu:(NSInteger)mtu {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
        self.mtu = mtu;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"",
            nil];
}

@end
