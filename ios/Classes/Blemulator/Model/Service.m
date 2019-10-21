#import "Service.h"

@implementation Service

- (instancetype)initWithObjectId:(int)objectId
                            uuid:(CBUUID *)uuid
            peripheralIdentifier:(NSString *)peripheralIdentifier
                       isPrimary:(BOOL)isPrimary {
    self = [super init];
    if (self) {
        self.objectId = objectId;
        self.uuid = uuid;
        self.peripheralIdentifier = peripheralIdentifier;
        self.isPrimary = isPrimary;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:_objectId], @"id",
            [_uuid UUIDString].lowercaseString, @"uuid",
            nil];
}

@end
