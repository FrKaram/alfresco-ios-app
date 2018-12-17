//
//  actionChoice.m
//  AlfrescoApp
//
//  Created by FKA on 13/12/2018.
//  Copyright © 2018 Alfresco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "actionChoice.h"

@implementation actionChoice

- (actionChoice*)init:(NSString *) actionValue
        actionName:(NSString *) actionName
        actionPropertyName:(NSString *) actionPropertyName
        requiresReason:(Boolean) requiresReason
{
    self = [super init];
    if (self)
    {
        self.actionValue = actionValue;
        self.actionName = actionName;
        self.actionPropertyName = actionPropertyName;
        self.requiresReason = requiresReason;
    }
    return self;
}

@end
