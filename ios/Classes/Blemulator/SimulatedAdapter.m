#import "SimulatedAdapter.h"
#import <flutter_ble_lib-Swift.h>

@interface SimulatedAdapter () <BleAdapter>

@end

@implementation SimulatedAdapter
/*
- (void)cancelDeviceConnection:(NSString * _Nonnull)deviceIdentifier resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)cancelTransaction:(NSString * _Nonnull)transactionId {
    <#code#>
}

- (void)characteristicsForDevice:(NSString * _Nonnull)deviceIdentifier serviceUUID:(NSString * _Nonnull)serviceUUID resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)characteristicsForService:(double)serviceIdentifier resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)connectToDevice:(NSString * _Nonnull)deviceIdentifier options:(NSDictionary<NSString *,id> * _Nullable)options resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)connectedDevices:(NSArray<NSString *> * _Nonnull)serviceUUIDs resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)devices:(NSArray<NSString *> * _Nonnull)deviceIdentifiers resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)disable:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)discoverAllServicesAndCharacteristicsForDevice:(NSString * _Nonnull)deviceIdentifier transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)enable:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (nonnull instancetype)initWithQueue:(dispatch_queue_t _Nonnull)queue restoreIdentifierKey:(NSString * _Nullable)restoreIdentifierKey {
    <#code#>
}

- (void)invalidate {
    <#code#>
}

- (void)isDeviceConnected:(NSString * _Nonnull)deviceIdentifier resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)logLevel:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)monitorCharacteristic:(double)characteristicIdentifier transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)monitorCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier serviceUUID:(NSString * _Nonnull)serviceUUID characteristicUUID:(NSString * _Nonnull)characteristicUUID transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)monitorCharacteristicForService:(double)serviceIdentifier characteristicUUID:(NSString * _Nonnull)characteristicUUID transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)readCharacteristic:(double)characteristicIdentifier transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)readCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier serviceUUID:(NSString * _Nonnull)serviceUUID characteristicUUID:(NSString * _Nonnull)characteristicUUID transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)readCharacteristicForService:(double)serviceIdentifier characteristicUUID:(NSString * _Nonnull)characteristicUUID transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)readRSSIForDevice:(NSString * _Nonnull)deviceIdentifier transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)requestConnectionPriorityForDevice:(NSString * _Nonnull)deviceIdentifier connectionPriority:(NSInteger)connectionPriority transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)requestMTUForDevice:(NSString * _Nonnull)deviceIdentifier mtu:(NSInteger)mtu transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)servicesForDevice:(NSString * _Nonnull)deviceIdentifier resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)setLogLevel:(NSString * _Nonnull)logLevel {
    <#code#>
}

- (void)startDeviceScan:(NSArray<NSString *> * _Nullable)filteredUUIDs options:(NSDictionary<NSString *,id> * _Nullable)options {
    <#code#>
}

- (void)state:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)stopDeviceScan {
    <#code#>
}

- (void)writeCharacteristic:(double)characteristicIdentifier valueBase64:(NSString * _Nonnull)valueBase64 response:(BOOL)response transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)writeCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier serviceUUID:(NSString * _Nonnull)serviceUUID characteristicUUID:(NSString * _Nonnull)characteristicUUID valueBase64:(NSString * _Nonnull)valueBase64 response:(BOOL)response transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}

- (void)writeCharacteristicForService:(double)serviceIdentifier characteristicUUID:(NSString * _Nonnull)characteristicUUID valueBase64:(NSString * _Nonnull)valueBase64 response:(BOOL)response transactionId:(NSString * _Nonnull)transactionId resolve:(void (^ _Nonnull)(id _Nullable))resolve reject:(void (^ _Nonnull)(NSString * _Nullable, NSString * _Nullable, NSError * _Nullable))reject {
    <#code#>
}
*/
@end
