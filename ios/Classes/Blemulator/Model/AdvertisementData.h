#import <CoreBluetooth/CoreBluetooth.h>

@interface AdvertisementData : NSObject

@property NSData * _Nullable manufacturerData;
@property NSDictionary<CBUUID *, NSData *> * _Nullable serviceData;
@property NSArray<CBUUID *> * _Nullable serviceUUIDs;
@property NSString * _Nullable localName;
@property NSNumber * _Nullable txPowerLevel;
@property NSArray<CBUUID *> * _Nullable solicitedServiceUUIDs;
@property BOOL * _Nullable isConnectable;
@property NSArray<CBUUID *> * _Nullable overflowServiceUUIDs;

- (instancetype _Nonnull)initWithManufacturerData:(NSData * _Nullable)manufacturerData
                                      serviceData:(NSDictionary<CBUUID *, NSData *> * _Nullable)serviceData
                                     serviceUUIDs:(NSArray<CBUUID *> * _Nullable)serviceUUIDs
                                        localName:(NSString * _Nullable)localName
                                     txPowerLevel:(NSNumber * _Nullable)txPowerLevel
                            solicitedServiceUUIDs:(NSArray<CBUUID *> * _Nullable)solicitedServiceUUIDs
                                    isConnectable:(BOOL * _Nullable)isConnectable
                             overflowServiceUUIDs:(NSArray<CBUUID *> * _Nullable)overflowServiceUUIDs;

@end
