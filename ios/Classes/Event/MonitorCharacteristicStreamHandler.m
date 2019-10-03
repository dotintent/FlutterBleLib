#import "MonitorCharacteristicStreamHandler.h"

@implementation MonitorCharacteristicStreamHandler {
    FlutterEventSink characteristicEventSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    characteristicEventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    characteristicEventSink = events;
    return nil;
}

- (void)onReadEvent:(id)value {
    if (characteristicEventSink != nil) {
        characteristicEventSink(value);
    }
}

@end
