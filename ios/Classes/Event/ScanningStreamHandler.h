#import <Flutter/Flutter.h>

@interface ScanningStreamHandler : NSObject<FlutterStreamHandler>

- (void)onScanResult:(id)scanResult;
- (void)onComplete;

@end
