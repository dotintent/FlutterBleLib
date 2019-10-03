#import <Flutter/Flutter.h>

@interface MonitorCharacteristicStreamHandler : NSObject<FlutterStreamHandler>

- (void)onReadEvent:(NSArray *)readResult;

@end
