#import "SimulatedAdapter.h"
#import <flutter_ble_lib-Swift.h>
#import "CommonTypes.h"
#import "DeviceContainer.h"
#import "BleError.h"

@interface SimulatedAdapter () <BleAdapter>

@property DartMethodCaller *dartMethodCaller;
@property DartValueHandler *dartValueHandler;
@property NSMutableDictionary<NSString *, DeviceContainer *> *knownPeripherals;
@property NSString *logLevelValue;

@end

@implementation SimulatedAdapter

// MARK: - Synthesize properties

@synthesize delegate;

// MARK: - DartValueHandlerScanEventDelegate implementation

- (void)dispatchDartValueHandlerScanEvent:(ScannedPeripheral *)scannedPeripheral {
    NSString *deviceId = scannedPeripheral.peripheral.identifier;
    if (![self.knownPeripherals objectForKey:deviceId]) {
        NSString *deviceName = scannedPeripheral.peripheral.name;
        DeviceContainer *device = [[DeviceContainer alloc] initWithIdentifier:deviceId
                                                                         name:deviceName];
        [self.knownPeripherals setObject:device forKey:deviceId];
    }
    [self.delegate dispatchEvent:BleEvent.scanEvent
                           value:[NSArray arrayWithObjects:[NSNull null], [scannedPeripheral jsonObjectRepresentation], nil]];
}

// MARK: - DartValueHandlerConnectionsEventDelegate implementation

- (void)dispatchDartValueHandlerConnectionStateEvent:(ConnectionStateEvent *)connectionStateEvent {
    NSString *deviceId = connectionStateEvent.deviceId;
    NSString *connectionState = connectionStateEvent.connectionState;
    if ([connectionState isEqualToString:@"CONNECTING"]) {
        [self.knownPeripherals objectForKey:deviceId].isConnected = false;
        [self.delegate dispatchEvent:BleEvent.connectingEvent value:deviceId];
    } else if ([connectionState isEqualToString:@"CONNECTED"]) {
        [self.knownPeripherals objectForKey:deviceId].isConnected = true;
        [self.delegate dispatchEvent:BleEvent.connectedEvent value:deviceId];
    } else if ([connectionState isEqualToString:@"DISCONNECTED"]) {
        [self.knownPeripherals objectForKey:deviceId].isConnected = false;
        [self.delegate dispatchEvent:BleEvent.disconnectionEvent value:[NSArray arrayWithObjects: [NSNull null],
                                                                        [connectionStateEvent jsonObjectRepresentation],
                                                                        nil]];
    }
}

// MARK: - Initializer

- (instancetype)initWithDartMethodCaller:(DartMethodCaller *)dartMethodCaller
                        dartValueHandler:(DartValueHandler *)dartValueHandler {
    NSLog(@"SimulatedAdapter.createClient");
    self = [super init];
    if (self) {
        self.dartMethodCaller = dartMethodCaller;
        self.dartValueHandler = dartValueHandler;
        self.knownPeripherals = [[NSMutableDictionary alloc] init];
        self.logLevelValue = @"None";

        [self.dartMethodCaller createClient];
    }
    return self;
}

// MARK: - Adapter Methods - BleClient lifecycle

- (nonnull instancetype)initWithQueue:(dispatch_queue_t _Nonnull)queue
                 restoreIdentifierKey:(NSString * _Nullable)restoreIdentifierKey {
    return [SimulatedAdapter new];
}

- (void)invalidate {
    NSLog(@"SimulatedAdapter.invalidate");
}

// MARK: - Adapter Methods - Scanning

- (void)startDeviceScan:(NSArray<NSString *> * _Nullable)filteredUUIDs
                options:(NSDictionary<NSString *,id> * _Nullable)options {
    NSLog(@"SimulatedAdapter.startDeviceScan");
    self.dartValueHandler.scanEventDelegate = self;
    [self.dartMethodCaller startDeviceScan];
}

- (void)stopDeviceScan {
    NSLog(@"SimulatedAdapter.stopDeviceScan");
    [self.dartMethodCaller stopDeviceScan];
    self.dartValueHandler.scanEventDelegate = nil;
}

// MARK: - Adapter Methods -  BT state monitoring

- (void)enable:(NSString * _Nonnull)transactionId
       resolve:(NS_NOESCAPE Resolve)resolve
        reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.enable");
}

- (void)disable:(NSString * _Nonnull)transactionId
        resolve:(NS_NOESCAPE Resolve)resolve
         reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.disable");
}

- (void)state:(NS_NOESCAPE Resolve)resolve
       reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.state");
}

// MARK: - Adapter Methods -  Connection

- (void)connectToDevice:(NSString * _Nonnull)deviceIdentifier
                options:(NSDictionary<NSString *,id> * _Nullable)options
                resolve:(Resolve)resolve
                 reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.connectToDevice");
    self.dartValueHandler.connectionEventDelegate = self;
    [self.dartMethodCaller connectToDevice:deviceIdentifier
                                      name:[self.knownPeripherals objectForKey:deviceIdentifier].name
                                   options:options
                                   resolve:resolve
                                    reject:reject];
}

- (void)cancelDeviceConnection:(NSString * _Nonnull)deviceIdentifier
                       resolve:(Resolve)resolve
                        reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.cancelDeviceConnection");
    [self.dartMethodCaller cancelDeviceConnection:deviceIdentifier
                                             name:[self.knownPeripherals objectForKey:deviceIdentifier].name
                                          resolve:resolve
                                           reject:reject];
}

- (void)isDeviceConnected:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.isDeviceConnected");
    [self.dartMethodCaller isDeviceConnected:deviceIdentifier
                                     resolve:resolve
                                      reject:reject];
}

- (void)requestConnectionPriorityForDevice:(NSString * _Nonnull)deviceIdentifier
                        connectionPriority:(NSInteger)connectionPriority
                             transactionId:(NSString * _Nonnull)transactionId
                                   resolve:(Resolve)resolve
                                    reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.requestConnectionPriorityForDevice");
}

// MARK: - Adapter Methods - Log Level

- (void)setLogLevel:(NSString * _Nonnull)logLevel {
    NSLog(@"setLogLevel: %@", logLevel);
    self.logLevelValue = logLevel;
}

- (void)logLevel:(NS_NOESCAPE Resolve)resolve
          reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.logLevel");
    resolve(self.logLevelValue);
}

// MARK: - Adapter Methods - Discovery

- (void)servicesForDevice:(NSString * _Nonnull)deviceIdentifier
                  resolve:(NS_NOESCAPE Resolve)resolve
                   reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.servicesForDevice");
    DeviceContainer *deviceContainer = [self.knownPeripherals objectForKey:deviceIdentifier];
    if (!deviceContainer.isConnected) {
        BleError *bleError = [[BleError alloc] initWithErrorCode:BleErrorCodeDeviceNotConnected
                                                          reason:@"Device not connected"];
        [bleError callReject:reject];
    }
    resolve([deviceContainer servicesJsonRepresentation]);
}

- (void)discoverAllServicesAndCharacteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                                         transactionId:(NSString * _Nonnull)transactionId
                                               resolve:(Resolve)resolve
                                                reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.discoverAllServicesAndCharacteristicsForDevice");
    Resolve callbackResolve = ^(DeviceContainer *container) {
        DeviceContainer *oldContainer = [self.knownPeripherals objectForKey:container.identifier];
        if (oldContainer != nil) {
            container.isConnected = oldContainer.isConnected;
        }
        [self.knownPeripherals setObject:container forKey:container.identifier];
        resolve([[[Peripheral alloc] initWithIdentifier:container.identifier
                                                   name:container.name] jsonObjectRepresentation]);
    };
    [self.dartMethodCaller discoverAllServicesAndCharacteristics:deviceIdentifier
                                                            name:[self.knownPeripherals objectForKey:deviceIdentifier].name
                                                   transactionId:transactionId
                                                         resolve:callbackResolve
                                                          reject:reject];
}

// UNUSED
- (void)characteristicsForDevice:(NSString * _Nonnull)deviceIdentifier
                     serviceUUID:(NSString * _Nonnull)serviceUUID
                         resolve:(NS_NOESCAPE Resolve)resolve
                          reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.characteristicsForDevice");
}

- (void)characteristicsForService:(double)serviceIdentifier
                          resolve:(NS_NOESCAPE Resolve)resolve
                           reject:(NS_NOESCAPE Reject)reject {
    NSLog(@"SimulatedAdapter.characteristicsForService");
    for (DeviceContainer *container in [self.knownPeripherals allValues]) {
        for (Service *service in container.services) {
            if (service.objectId == serviceIdentifier) {
                resolve([container characteristicsJsonRepresentationForService:[service.uuid UUIDString]]);
                return;
            }
        }
    }
    BleError *bleError = [[BleError alloc] initWithErrorCode:BleErrorCodeServiceNotFound
                                                      reason:[NSString stringWithFormat:@"Service with id %.0f not found", serviceIdentifier]];
    [bleError callReject:reject];
}

// MARK: - Adapter Methods - Characteristics observation

- (void)readCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                        serviceUUID:(NSString * _Nonnull)serviceUUID
                 characteristicUUID:(NSString * _Nonnull)characteristicUUID
                      transactionId:(NSString * _Nonnull)transactionId
                            resolve:(Resolve)resolve
                             reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.readCharacteristicForDevice");
    [self.dartMethodCaller readCharacteristicForDevice:deviceIdentifier
                                           serviceUUID:serviceUUID
                                    characteristicUUID:characteristicUUID
                                         transactionId:transactionId
                                               resolve:resolve
                                                reject:reject];
}

- (void)readCharacteristicForService:(double)serviceIdentifier
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.readCharacteristicForService");
    [self.dartMethodCaller readCharacteristicForService:serviceIdentifier
                                     characteristicUUID:characteristicUUID
                                          transactionId:transactionId
                                                resolve:resolve
                                                 reject:reject];
}

- (void)readCharacteristic:(double)characteristicIdentifier
             transactionId:(NSString * _Nonnull)transactionId
                   resolve:(Resolve)resolve
                    reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.readCharacteristic");
    [self.dartMethodCaller readCharacteristic:characteristicIdentifier
                                transactionId:(NSString *)transactionId
                                      resolve:resolve
                                       reject:reject];
}

- (void)writeCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                         serviceUUID:(NSString * _Nonnull)serviceUUID
                  characteristicUUID:(NSString * _Nonnull)characteristicUUID valueBase64:(NSString * _Nonnull)valueBase64
                            response:(BOOL)response
                       transactionId:(NSString * _Nonnull)transactionId
                             resolve:(Resolve)resolve
                              reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.writeCharacteristicForDevice");
    [self.dartMethodCaller writeCharacteristicForDevice:deviceIdentifier
                                            serviceUUID:serviceUUID
                                     characteristicUUID:characteristicUUID
                                                  value:valueBase64
                                          transactionId:transactionId
                                                resolve:resolve
                                                 reject:reject];
}

- (void)writeCharacteristicForService:(double)serviceIdentifier
                   characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          valueBase64:(NSString * _Nonnull)valueBase64
                             response:(BOOL)response
                        transactionId:(NSString * _Nonnull)transactionId
                              resolve:(Resolve)resolve
                               reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.writeCharacteristicForService");
    [self.dartMethodCaller writeCharacteristicForService:serviceIdentifier
                                      characteristicUUID:characteristicUUID
                                                   value:valueBase64
                                           transactionId:transactionId
                                                 resolve:resolve
                                                  reject:reject];
}

- (void)writeCharacteristic:(double)characteristicIdentifier
                valueBase64:(NSString * _Nonnull)valueBase64
                   response:(BOOL)response
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.writeCharacteristic");
    [self.dartMethodCaller writeCharacteristic:characteristicIdentifier
                                         value:valueBase64
                                 transactionId:transactionId
                                       resolve:resolve
                                        reject:reject];
}

- (void)monitorCharacteristicForDevice:(NSString * _Nonnull)deviceIdentifier
                           serviceUUID:(NSString * _Nonnull)serviceUUID
                    characteristicUUID:(NSString * _Nonnull)characteristicUUID
                         transactionId:(NSString * _Nonnull)transactionId
                               resolve:(Resolve)resolve
                                reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.monitorCharacteristicForDevice");
}

- (void)monitorCharacteristicForService:(double)serviceIdentifier
                     characteristicUUID:(NSString * _Nonnull)characteristicUUID
                          transactionId:(NSString * _Nonnull)transactionId
                                resolve:(Resolve)resolve
                                 reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.monitorCharacteristicForService");
}

- (void)monitorCharacteristic:(double)characteristicIdentifier
                transactionId:(NSString * _Nonnull)transactionId
                      resolve:(Resolve)resolve
                       reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.monitorCharacteristic");
}

// MARK: - Adapter Methods - Known / Connected devices

- (void)devices:(NSArray<NSString *> * _Nonnull)deviceIdentifiers
        resolve:(Resolve)resolve
         reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.devices");
}

- (void)connectedDevices:(NSArray<NSString *> * _Nonnull)serviceUUIDs
                 resolve:(Resolve)resolve
                  reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.connectedDevices");
}

// MARK: - Adapter Methods - MTU

- (void)requestMTUForDevice:(NSString * _Nonnull)deviceIdentifier mtu:(NSInteger)mtu
              transactionId:(NSString * _Nonnull)transactionId
                    resolve:(Resolve)resolve
                     reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.requestMTUForDevice");
}

// MARK: - Adapter Methods - RSSI

- (void)readRSSIForDevice:(NSString * _Nonnull)deviceIdentifier
            transactionId:(NSString * _Nonnull)transactionId
                  resolve:(Resolve)resolve
                   reject:(Reject)reject {
    NSLog(@"SimulatedAdapter.readRSSIForDevice");
}

// MARK: - Adapter Methods - Cancel transaction

- (void)cancelTransaction:(NSString * _Nonnull)transactionId {
    NSLog(@"SimulatedAdapter.cancelTransaction");
}

@end
