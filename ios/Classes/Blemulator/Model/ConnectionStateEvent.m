#import "ConnectionStateEvent.h"

NSString * const JSON_KEY_ID = @"id";
NSString * const JSON_KEY_CONNECTION_STATE = @"connectionState";

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
            _deviceId, JSON_KEY_ID,
            _connectionState, JSON_KEY_CONNECTION_STATE,
            nil];
}

@end
