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

// MARK: - Discovery

- (void)discoverAllServicesAndCharacteristics:(NSString *)deviceIdentifier
                                         name:(NSString *)name
                                transactionId:(NSString *)transactionId
                                      resolve:(Resolve)resolve
                                       reject:(Reject)reject;

// MARK: - Characteristics observation

- (void)readCharacteristicForDevice:(NSString *)deviceIdentifier
                        serviceUUID:(NSString *)serviceUUID
                 characteristicUUID:(NSString *)characteristicUUID
                            resolve:(Resolve)resolve
                             reject:(Reject)reject;

- (void)readCharacteristicForService:(int)serviceIdentifier
                  characteristicUUID:(NSString *)characteristicUUID
                             resolve:(Resolve)resolve
                              reject:(Reject)reject;

- (void)readCharacteristic:(int)characteristicIdentifier
                   resolve:(Resolve)resolve
                    reject:(Reject)reject;

@end
