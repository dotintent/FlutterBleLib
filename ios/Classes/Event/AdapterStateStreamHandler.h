#import <Flutter/Flutter.h>

@interface AdapterStateStreamHandler : NSObject<FlutterStreamHandler>

- (void)onNewAdapterState:(NSArray *)bluetoothAdapterState;

@end
