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

- (void)onNewAdapterState:(NSArray *)bluetoothAdapterState {
    @synchronized (self) {
        if (adapterStateSink != nil) {
            if (bluetoothAdapterState[0] == [NSNull null]) {
                adapterStateSink(bluetoothAdapterState[1]);
            } else {
                adapterStateSink([FlutterErrorFactory flutterErrorFromJSONString:bluetoothAdapterState[0]]);
            }
        }
    }
}

@end
