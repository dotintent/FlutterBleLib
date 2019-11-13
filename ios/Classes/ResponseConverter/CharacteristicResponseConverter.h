@interface CharacteristicResponseConverter : NSObject

+ (NSString *)jsonStringFromCharacteristicResponse:(NSDictionary *)response
                                     transactionId:(NSString *)transactionId;

+ (NSString *)jsonStringFromCharacteristicsResponse:(NSArray *)characteristicsResponse;

+ (NSString *)jsonStringFromCharacteristicsResponse:(NSArray *)characteristicsResponse
                                            service:(NSDictionary *)service;

+ (NSArray *)characteristicsFromCharacteristicResponse:(NSArray *)characteristicsResponse;

@end
