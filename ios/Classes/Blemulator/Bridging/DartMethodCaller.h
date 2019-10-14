#import <Flutter/Flutter.h>
#import "CommonTypes.h"

@interface DartMethodCaller : NSObject

- (instancetype)initWithDartMethodChannel:(FlutterMethodChannel *)dartMethodChannel;

// MARK: - Methods - Lifecycle

- (void)createClient;

// MARK: - Methods - Scanning

- (void)startDeviceScan;

- (void)stopDeviceScan;

// MARK: - Methods - Connection

- (void)connectToDevice:(NSString *)deviceIdentifier
                   name:(NSString *)name
                options:(NSDictionary<NSString *,id> *)options
                resolve:(Resolve)resolve
                 reject:(Reject)reject;

- (void)cancelDeviceConnection:(NSString *)deviceIdentifier
                          name:(NSString *)name
                       resolve:(Resolve)resolve
                        reject:(Reject)reject;

- (void)isDeviceConnected:(NSString *)deviceIdentifier
                  resolve:(Resolve)resolve
                   reject:(Reject)reject;

@end
