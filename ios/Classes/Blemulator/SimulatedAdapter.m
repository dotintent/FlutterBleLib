#import "SimulatedAdapter.h"
#import <flutter_ble_lib-Swift.h>
#import "CommonTypes.h"

@interface SimulatedAdapter () <BleAdapter>

@end

@implementation SimulatedAdapter

@synthesize delegate;

// MARK: - MBA Methods - BleClient lifecycle

- (nonnull instancetype)initWithQueue:(dispatch_queue_t _Nonnull)queue
                 restoreIdentifierKey:(NSString * _Nullable)restoreIdentifierKey {
    return [SimulatedAdapter new];
}

- (void)invalidate {
    NSLog(@"invalidate");
}

// MARK: - MBA Methods - Scanning

- (void)startDeviceScan:(NSArray<NSString *> * _Nullable)filteredUUIDs
                options:(NSDictionary<NSString *,id> * _Nullable)options {
    NSLog(@"startDeviceScan");
}

- (void)stopDeviceScan {
    NSLog(@"stopDeviceScan");
}

// MARK: - MBA Methods - Connection

- (void)connectToDevice:(NSString * _Nonnull)deviceIdentifier
                options:(NSDictionary<NSString *,id> * _Nullable)options
                resolve:(Resolve)resolve reject:(Reject)reject {
    NSLog(@"connectToDevice");
}

- (void)cancelDeviceConnection:(NSString * _Nonnull)deviceIdentifier
                       resolve:(Resolve)resolve
                        reject:(Reject)reject {
    NSLog(@"cancelDeviceConnection");
}

- (void)isDeviceConnected:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"isDeviceConnected");
}

// MARK: - MBA Methods - Log Level

- (void)setLogLevel:(NSString * _Nonnull)logLevel {
    NSLog(@"setLogLevel");
}

- (void)logLevel:(NS_NOESCAPE Resolve)resolve
          reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"logLevel");
}

// MARK: - MBA Methods - Discovery

- (void)servicesForDevice:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"servicesForDevice");
}

- (void)discoverAllServicesAndCharacteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                                         transactionId:(NSString * _Nonnull)transactionId
                                               resolve:(Resolve)resolve
                                                reject:(Reject)reject {
    NSLog(@"discoverAllServicesAndCharacteristicsForDevice");
}

// UNUSED
- (void)characteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                     serviceUUID:(NSString * _Nonnull)serviceUUID
                         resolve:(NS_NOESCAPE Resolve)resolve
                          reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"characteristicsForDevice");
}

- (void)characteristicsForService:(double)serviceIdentifier
                          resolve:(NS_NOESCAPE Resolve)resolve
                           reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"characteristicsForService");
}

- (void)cancelTransaction:(NSString * _Nonnull)transactionId {
    NSLog(@"cancelTransaction");
}

// MARK: - MBA Methods - Characteristics observation

- (void)readCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                        serviceUUID:(NSString * _Nonnull)serviceUUID
                 characteristicUUID:(NSString * _Nonnull)characteristicUUID
                      transactionId:(NSString * _Nonnull)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject {
    NSLog(@"readCharacteristicForDevice");
}

- (void)readCharacteristicForService:(double)serviceIdentifier
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {
    NSLog(@"readCharacteristicForService");
}

- (void)readCharacteristic:(double)characteristicIdentifier
             transactionId:(NSString * _Nonnull)transactionId
                   resolve:(Resolve)resolve
                    reject:(Reject)reject {
    NSLog(@"readCharacteristic");
}

- (void)writeCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                         serviceUUID:(NSString * _Nonnull)serviceUUID
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID valueBase64:(NSString * _Nonnull)valueBase64
                            response:(BOOL)response
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {
    NSLog(@"writeCharacteristicForDevice");
}

- (void)writeCharacteristicForService:(double)serviceIdentifier
                   characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          valueBase64:(NSString * _Nonnull)valueBase64
                             response:(BOOL)response
                        transactionId:(NSString * _Nonnull)transactionId
                              resolve:(Resolve)resolve
                               reject:(Reject)reject {
    NSLog(@"writeCharacteristicForService");
}

- (void)writeCharacteristic:(double)characteristicIdentifier
                valueBase64:(NSString * _Nonnull)valueBase64
                   response:(BOOL)response
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve reject:(Reject)reject {
    NSLog(@"writeCharacteristic");
}

- (void)monitorCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                           serviceUUID:(NSString * _Nonnull)serviceUUID
                    characteristicUUID:(NSString * _Nonnull)characteristicUUID
                         transactionId:(NSString * _Nonnull)transactionId
                               resolve:(Resolve)resolve
                                reject:(Reject)reject {
    NSLog(@"monitorCharacteristicForDevice");
}

- (void)monitorCharacteristicForService:(double)serviceIdentifier
                     characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          transactionId:(NSString * _Nonnull)transactionId
                                resolve:(Resolve)resolve
                                 reject:(Reject)reject {
    NSLog(@"monitorCharacteristicForService");
}

- (void)monitorCharacteristic:(double)characteristicIdentifier
                transactionId:(NSString * _Nonnull)transactionId
                      resolve:(Resolve)resolve
                       reject:(Reject)reject {
    NSLog(@"monitorCharacteristic");
}

// MARK: - MBA Methods - Known / Connected devices

- (void)devices:(NSArray<NSString *> * _Nonnull)deviceIdentifiers
        resolve:(Resolve)resolve
         reject:(Reject)reject {
    NSLog(@"devices");
}

- (void)connectedDevices:(NSArray<NSString *> * _Nonnull)serviceUUIDs
                 resolve:(Resolve)resolve
                  reject:(Reject)reject {
    NSLog(@"connectedDevices");
}

// MARK: - MBA Methods - MTU

- (void)requestMTUForDevice:(NSString * _Nonnull)deviceIdentifier mtu:(NSInteger)mtu
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve
                     reject:(Reject)reject {
    NSLog(@"requestMTUForDevice");
}

// MARK: - MBA Methods - RSSI

- (void)readRSSIForDevice:(NSString * _Nonnull)deviceIdentifier
            transactionId:(NSString * _Nonnull)transactionId
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {
    NSLog(@"readRSSIForDevice");
}

// MARK: - MBA Methods - Cancel transaction

- (void)disable:(NSString * _Nonnull)transactionId
        resolve:(NS_NOESCAPE Resolve)resolve
         reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"disable");
}

- (void)enable:(NSString * _Nonnull)transactionId
       resolve:(NS_NOESCAPE Resolve)resolve
        reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"enable");
}

- (void)requestConnectionPriorityForDevice:(NSString * _Nonnull)deviceIdentifier
                        connectionPriority:(NSInteger)connectionPriority
                             transactionId:(NSString * _Nonnull)transactionId
                                   resolve:(Resolve)resolve
                                    reject:(Reject)reject {
    NSLog(@"requestConnectionPriorityForDevice");
}

- (void)state:(NS_NOESCAPE Resolve)resolve
       reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"state");
}

@end


