@interface CharacteristicResponseConverter : NSObject

+ (NSString *)jsonStringFromCharacteristicResponse:(NSDictionary *)response
                                     transactionId:(NSString *)transactionId;

@end
