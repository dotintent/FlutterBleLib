#import "FlutterMethodCallHandler.h"

@interface SimulatorPlugin : NSObject<FlutterMethodCallHandler>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

@end
