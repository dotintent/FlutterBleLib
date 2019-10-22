#import "RestoreStateStreamHandler.h"
#import "JSONStringifier.h"

@implementation RestoreStateStreamHandler {
    FlutterEventSink restoreStateSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        restoreStateSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        restoreStateSink = events;
        return nil;
    }
}

- (void)onRestoreEvent:(id)restoreState {
    @synchronized (self) {
        if (restoreStateSink != nil && restoreState != [NSNull null]) {
            NSArray *connectedPeripherals = [restoreState objectForKey:@"connectedPeripherals"];
            restoreStateSink([JSONStringifier jsonStringFromJSONObject:connectedPeripherals]);
        }
    }
}

@end
