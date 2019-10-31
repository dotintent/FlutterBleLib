#import <Flutter/Flutter.h>

@interface ScanningStreamHandler : NSObject<FlutterStreamHandler>

- (void)onScanResult:(NSArray *)scanResult;
- (void)onComplete;

@end
