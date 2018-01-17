#import "FlutterBleLibPlugin.h"
#import "Methods.h"
#import "BleData/Bledata.pbobjc.h"
#import "Converter.h"
#import <flutter_ble_lib/flutter_ble_lib-Swift.h>

@interface FlutterBleLibPlugin ()
@property(nonatomic) BleClientManager* manager;
@end


@implementation FlutterBleLibPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_ble_lib"
            binaryMessenger:[registrar messenger]];
  FlutterBleLibPlugin* instance = [[FlutterBleLibPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
  if([FBLCreateClient isEqualToString:call.method]) {
      //TODO flutter should pass something here.
      [self createClient:nil];
  } else if([FBLDestroyClient isEqualToString:call.method]) {
      [self destroyClient];
  } else if([FBLSetLogLevel isEqualToString:call.method]) {
      [self setLogLevel:call.arguments];
  } else if([FBLCancelTransaction isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLLogLevel isEqualToString:call.method]) {
      [self logLevel:result];
  } else if([FBLState isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLStartDeviceScan isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLStopDeviceScan isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLRequestMTUForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadRSSIForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLConnectToDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCancelDeviceConnection isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLIsDeviceConnected isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLDiscoverAllServicesAndCharacteristicsForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLServicesForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCharacteristicsForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLCharacteristicsForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLWriteCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLWriteCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristicForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLReadCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristicForDevice isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristicForService isEqualToString:call.method]) {
      //[self TBD];
  } else if([FBLMonitorCharacteristic isEqualToString:call.method]) {
      //[self TBD];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)createClient:(NSString*)restoreIdentifierKey {
    _manager = [[BleClientManager alloc] initWithQueue:dispatch_get_main_queue()
                                  restoreIdentifierKey:restoreIdentifierKey];
}

- (void)destroyClient {
    [_manager invalidate];
    _manager = nil;
}

- (void)invalidate {
    [self destroyClient];
}

- (void)setLogLevel:(NSString*)logLevel {
    [_manager setLogLevel:[logLevel capitalizedString]];
}

- (void)logLevel:(FlutterResult) result {
    [_manager logLevel:^(id _Nullable logLevel) {
        result(@([Converter convertToBleDataLogLevelMessage: (NSNumber*) logLevel]));
    }];
}

@end
