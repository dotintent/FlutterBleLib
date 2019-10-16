#import "Peripheral.h"
#import "AdvertisementData.h"

@interface ScannedPeripheral : NSObject

@property Peripheral * _Nonnull peripheral;
@property AdvertisementData * _Nonnull advertisementData;
@property NSNumber * _Nonnull rssi;

- (instancetype _Nonnull)initWithPeripheral:(Peripheral * _Nonnull)peripheral
                          advertisementData:(AdvertisementData * _Nonnull)advertisementData
                                       rssi:(NSNumber * _Nonnull)rssi;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
