#import "Service.h"

@implementation Service

- (instancetype)initWithObjectId:(uint)objectId
                            uuid:(CBUUID *)uuid
                      peripheral:(Peripheral *)peripheral
                       isPrimary:(BOOL)isPrimary {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.uuid = uuid;
        self.peripheral = peripheral;
        self.isPrimary = isPrimary;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"",
            nil];
}

@end
