#import <Flutter/Flutter.h>

@interface RestoreStateStreamHandler : NSObject<FlutterStreamHandler>

- (void)onRestoreEvent:(id)restoreStateIdentifier;

@end
