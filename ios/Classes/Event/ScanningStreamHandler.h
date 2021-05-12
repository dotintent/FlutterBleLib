#import <Flutter/Flutter.h>
@import MultiplatformBleAdapter;

@interface ScanningStreamHandler : NSObject<FlutterStreamHandler>

- (void)attachAdatper:(id <BleAdapter>)adapter;
- (void)detachAdapter;
- (void)stopDeviceScan:(FlutterResult)result;
- (void)onScanResult:(NSArray *)scanResult;

@end
