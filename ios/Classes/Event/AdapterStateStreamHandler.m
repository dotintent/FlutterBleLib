#import "AdapterStateStreamHandler.h"
#import "FlutterErrorFactory.h"

@implementation AdapterStateStreamHandler {
    FlutterEventSink adapterStateSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        adapterStateSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        adapterStateSink = events;
        return nil;
    }
}

- (void)onNewAdapterState:(NSString *)bluetoothAdapterState {
    @synchronized (self) {
        if (adapterStateSink != nil) {
            adapterStateSink(bluetoothAdapterState);
        }
    }
}

@end
