#import "SimulatedAdapter.h"
#import <flutter_ble_lib-Swift.h>
#import "CommonTypes.h"

@interface SimulatedAdapter () <BleAdapter>

@end

@implementation SimulatedAdapter

@synthesize delegate;

- (nonnull instancetype)initWithQueue:(dispatch_queue_t _Nonnull)queue
                 restoreIdentifierKey:(NSString * _Nullable)restoreIdentifierKey {
    return [SimulatedAdapter new];
}

- (void)cancelDeviceConnection:(NSString * _Nonnull)deviceIdentifier
                       resolve:(Resolve)resolve
                        reject:(Reject)reject {

}

- (void)cancelTransaction:(NSString * _Nonnull)transactionId {

}

- (void)characteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                     serviceUUID:(NSString * _Nonnull)serviceUUID
                         resolve:(NS_NOESCAPE Resolve)resolve
                          reject:(NS_NOESCAPE Reject)reject {

}

- (void)characteristicsForService:(double)serviceIdentifier
                          resolve:(NS_NOESCAPE Resolve)resolve
                           reject:(NS_NOESCAPE Reject)reject {

}

- (void)connectToDevice:(NSString * _Nonnull)deviceIdentifier
                options:(NSDictionary<NSString *,id> * _Nullable)options
                resolve:(Resolve)resolve reject:(Reject)reject {

}

- (void)connectedDevices:(NSArray<NSString *> * _Nonnull)serviceUUIDs
                 resolve:(Resolve)resolve
                  reject:(Reject)reject {

}

- (void)devices:(NSArray<NSString *> * _Nonnull)deviceIdentifiers
        resolve:(Resolve)resolve
         reject:(Reject)reject {

}

- (void)disable:(NSString * _Nonnull)transactionId
        resolve:(NS_NOESCAPE Resolve)resolve
         reject:(NS_NOESCAPE Reject)reject {

}

- (void)discoverAllServicesAndCharacteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                                         transactionId:(NSString * _Nonnull)transactionId
                                               resolve:(Resolve)resolve
                                                reject:(Reject)reject {

}

- (void)enable:(NSString * _Nonnull)transactionId
       resolve:(NS_NOESCAPE Resolve)resolve
        reject:(NS_NOESCAPE Reject)reject {

}

- (void)invalidate {

}

- (void)isDeviceConnected:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {

}

- (void)logLevel:(NS_NOESCAPE Resolve)resolve
          reject:(NS_NOESCAPE Reject)reject {

}

- (void)monitorCharacteristic:(double)characteristicIdentifier
                transactionId:(NSString * _Nonnull)transactionId
                      resolve:(Resolve)resolve
                       reject:(Reject)reject {

}

- (void)monitorCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                           serviceUUID:(NSString * _Nonnull)serviceUUID
                    characteristicUUID:(NSString * _Nonnull)characteristicUUID
                         transactionId:(NSString * _Nonnull)transactionId
                               resolve:(Resolve)resolve
                                reject:(Reject)reject {

}

- (void)monitorCharacteristicForService:(double)serviceIdentifier
                     characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          transactionId:(NSString * _Nonnull)transactionId
                                resolve:(Resolve)resolve
                                 reject:(Reject)reject {

}

- (void)readCharacteristic:(double)characteristicIdentifier
             transactionId:(NSString * _Nonnull)transactionId
                   resolve:(Resolve)resolve
                    reject:(Reject)reject {

}

- (void)readCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                        serviceUUID:(NSString * _Nonnull)serviceUUID
                 characteristicUUID:(NSString * _Nonnull)characteristicUUID
                      transactionId:(NSString * _Nonnull)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject {

}

- (void)readCharacteristicForService:(double)serviceIdentifier
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {

}

- (void)readRSSIForDevice:(NSString * _Nonnull)deviceIdentifier
            transactionId:(NSString * _Nonnull)transactionId
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {

}

- (void)requestConnectionPriorityForDevice:(NSString * _Nonnull)deviceIdentifier
                        connectionPriority:(NSInteger)connectionPriority
                             transactionId:(NSString * _Nonnull)transactionId
                                   resolve:(Resolve)resolve
                                    reject:(Reject)reject {

}

- (void)requestMTUForDevice:(NSString * _Nonnull)deviceIdentifier mtu:(NSInteger)mtu
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve
                     reject:(Reject)reject {

}

- (void)servicesForDevice:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {

}

- (void)setLogLevel:(NSString * _Nonnull)logLevel {

}

- (void)startDeviceScan:(NSArray<NSString *> * _Nullable)filteredUUIDs
                options:(NSDictionary<NSString *,id> * _Nullable)options {

}

- (void)state:(NS_NOESCAPE Resolve)resolve
       reject:(NS_NOESCAPE Reject)reject {

}

- (void)stopDeviceScan {

}

- (void)writeCharacteristic:(double)characteristicIdentifier
                valueBase64:(NSString * _Nonnull)valueBase64
                   response:(BOOL)response
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve reject:(Reject)reject {

}

- (void)writeCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                         serviceUUID:(NSString * _Nonnull)serviceUUID
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID valueBase64:(NSString * _Nonnull)valueBase64 
                            response:(BOOL)response
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {

}

- (void)writeCharacteristicForService:(double)serviceIdentifier
                   characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          valueBase64:(NSString * _Nonnull)valueBase64
                             response:(BOOL)response
                        transactionId:(NSString * _Nonnull)transactionId
                              resolve:(Resolve)resolve
                               reject:(Reject)reject {

}

@end


