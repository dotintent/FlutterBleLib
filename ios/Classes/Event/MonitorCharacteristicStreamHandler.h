#import <Flutter/Flutter.h>

@interface MonitorCharacteristicStreamHandler : NSObject<FlutterStreamHandler>

- (void)onReadEvent:(id)value;

@end
