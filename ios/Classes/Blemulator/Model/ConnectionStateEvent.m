#import "ConnectionStateEvent.h"

@implementation ConnectionStateEvent

- (instancetype)initWith:(NSString *)deviceId connectionState:(NSString *)connectionState {
    self = [super init];
    if (self) {
        self.deviceId = deviceId;
        self.connectionState = connectionState;
    }
    return self;
}

- (NSDictionary<NSString *,id> *)jsonObjectRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _deviceId, @"id",
            _connectionState, @"connectionState",
            nil];
}

@end
