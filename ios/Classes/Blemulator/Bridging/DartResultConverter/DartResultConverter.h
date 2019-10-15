#import "DeviceContainer.h"

@interface DartResultConverter : NSObject

+ (DeviceContainer *)deviceContainerFromDartResult:(id)result
                           peripheral:(Peripheral *)peripheral;

@end
