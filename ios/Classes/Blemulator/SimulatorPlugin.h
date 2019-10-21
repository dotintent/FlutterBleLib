#import <Flutter/Flutter.h>

@interface SimulatorPlugin : NSObject<FlutterPlugin>

- (instancetype)initWithPlatformToDartChannel:(FlutterMethodChannel *)platformToDartChannel;

@end
