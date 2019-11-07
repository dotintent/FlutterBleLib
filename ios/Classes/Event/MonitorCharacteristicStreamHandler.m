#import "MonitorCharacteristicStreamHandler.h"
#import "CharacteristicResponseConverter.h"
#import "FlutterErrorFactory.h"

@implementation MonitorCharacteristicStreamHandler {
    FlutterEventSink characteristicEventSink;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    @synchronized (self) {
        characteristicEventSink = nil;
        return nil;
    }
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    @synchronized (self) {
        characteristicEventSink = events;
        return nil;
    }
}

- (void)onReadEvent:(NSArray *)readResult {
    @synchronized (self) {
        if (characteristicEventSink != nil) {
            if (readResult[0] == [NSNull null]) {
                characteristicEventSink([CharacteristicResponseConverter jsonStringFromCharacteristicResponse:readResult[1]
                                                                                                transactionId:readResult[2]]);
            } else {
                characteristicEventSink([FlutterErrorFactory flutterErrorFromJSONString:readResult[0]
                                                                      withTransactionId:readResult[2]]);
            }
        }
    }
}

@end
