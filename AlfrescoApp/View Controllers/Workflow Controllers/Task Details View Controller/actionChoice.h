#import <Foundation/Foundation.h>

@interface actionChoice : NSObject

@property NSString *actionValue;
@property NSString *actionName;
@property NSString *actionPropertyName;
@property Boolean requiresReason;

- (instancetype)init:(NSString *) actionValue
          actionName:(NSString *) actionName
  actionPropertyName:(NSString *) actionPropertyName
      requiresReason: (Boolean) requiresReason;

@end
