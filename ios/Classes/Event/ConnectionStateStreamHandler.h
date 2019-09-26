#import <Flutter/Flutter.h>

@interface ConnectionStateStreamHandler : NSObject<FlutterStreamHandler>

- (void)onConnectingEvent:(NSString *)deviceId;

- (void)onConnectedEvent:(NSString *)deviceId;

@end
