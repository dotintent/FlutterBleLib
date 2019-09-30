#import <Flutter/Flutter.h>

@interface AdapterStateStreamHandler : NSObject<FlutterStreamHandler>

- (void)onNewAdapterState:(id)bluetoothAdapterState;

@end
