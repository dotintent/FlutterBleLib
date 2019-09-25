#import "AdapterStateStreamHandler.h"

@implementation AdapterStateStreamHandler
{
    FlutterEventSink adapterStateSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    adapterStateSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    adapterStateSink = events;
    return nil;
}

- (void)onNewAdapterState:(id)bluetoothAdapterState {
    if (adapterStateSink != nil) {
        adapterStateSink(bluetoothAdapterState);
    }
}

@end
