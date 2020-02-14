@interface CharacteristicResponseConverter : NSObject

+ (NSString *)jsonStringFromCharacteristicResponse:(NSDictionary *)response
                                     transactionId:(NSString *)transactionId;

+ (NSString *)jsonStringFromCharacteristicsResponse:(NSArray *)characteristicsResponse;

+ (NSString *)jsonStringWithServiceFromCharacteristicsResponse:(NSArray *)characteristicsResponse;

+ (NSArray *)characteristicsFromCharacteristicResponse:(NSArray *)characteristicsResponse;

@end
