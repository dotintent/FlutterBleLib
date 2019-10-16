#import "Characteristic.h"

@implementation Characteristic

- (instancetype)initWithObjectId:(uint)objectId
                            uuid:(CBUUID *)uuid
                           value:(NSData *)value
                         service:(Service *)service
                     isNotifying:(BOOL)isNotifying {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.uuid = uuid;
        self.value = value;
        self.service = service;
        self.isNotifying = isNotifying;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"",
            nil];
}

@end
