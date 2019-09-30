#import <Flutter/Flutter.h>

@interface ConnectionStateStreamHandler : NSObject<FlutterStreamHandler>

- (void)onNewConnectionState:(id)connectionState;

@end
