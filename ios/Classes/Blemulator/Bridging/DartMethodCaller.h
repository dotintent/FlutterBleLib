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
                      transactionId:(NSString *)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject;

- (void)readCharacteristicForService:(int)serviceIdentifier
                  characteristicUUID:(NSString *)characteristicUUID
                       transactionId:(NSString *)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject;

- (void)readCharacteristic:(int)characteristicIdentifier
             transactionId:(NSString *)transactionId
                   resolve:(Resolve)resolve
                    reject:(Reject)reject;

- (void)writeCharacteristicForDevice:(NSString *)deviceIdentifier
                         serviceUUID:(NSString *)serviceUUID
                  characteristicUUID:(NSString *)characteristicUUID
                               value:(NSString *)value
                       transactionId:(NSString *)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject;

- (void)writeCharacteristicForService:(int)serviceIdentifier
                   characteristicUUID:(NSString *)characteristicUUID
                                value:(NSString *)value
                        transactionId:(NSString *)transactionId
                              resolve:(Resolve)resolve
                               reject:(Reject)reject;

- (void)writeCharacteristic:(int)characteristicIdentifier
                      value:(NSString *)value
              transactionId:(NSString *)transactionId
                    resolve:(Resolve)resolve
                     reject:(Reject)reject;

- (void)monitorCharacteristicForDevice:(NSString *)deviceIdentifier
                           serviceUUID:(NSString *)serviceUUID
                    characteristicUUID:(NSString *)characteristicUUID
                         transactionId:(NSString *)transactionId
                               resolve:(Resolve)resolve
                                reject:(Reject)reject;

- (void)monitorCharacteristicForService:(int)serviceIdentifier
                     characteristicUUID:(NSString *)characteristicUUID
                          transactionId:(NSString *)transactionId
                                resolve:(Resolve)resolve
                                 reject:(Reject)reject;

- (void)monitorCharacteristic:(int)characteristicIdentifier
                transactionId:(NSString *)transactionId
                      resolve:(Resolve)resolve
                       reject:(Reject)reject;

// MARK: - RSSI

- (void)readRSSIForDevice:(NSString *)deviceIdentifier
                     name:(NSString *)name
                  resolve:(Resolve)resolve
                   reject:(Reject)reject;
// MARK: - Cancel transaction

- (void)cancelTransaction:(NSString *)transactionId;

@end
