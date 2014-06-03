/*******************************************************************************
 * Copyright (C) 2005-2014 Alfresco Software Limited.
 * 
 * This file is part of the Alfresco Mobile iOS App.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *  
 *  http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
 
#import "ErrorDescriptions.h"
#import "ConnectivityManager.h"

static NSString * const kErrorDescriptionNetworkNotAvailable = @"error.no.internet.access.message";
static NSString * const kErrorDescriptionAccessPermissions = @"error.access.permissions.message";
static NSString * const kErrorDescriptionHostUnreachable = @"error.host.unreachable.message";
static NSString * const kErrorDescriptionLoginFailed = @"error.login.failed";

@implementation ErrorDescriptions

+ (NSString *)descriptionForError:(NSError *)error
{
    NSString *errorDescription = nil;
    
    if (error.code < 0 || ![[ConnectivityManager sharedManager] hasInternetConnection])
    {
        errorDescription = NSLocalizedString(kErrorDescriptionNetworkNotAvailable, @"Network not available");
    }
    else if ([error.domain isEqualToString:kAlfrescoErrorDomainName])
    {
        errorDescription = [self descriptionForAlfrescoError:error];
    }
    else
    {
        errorDescription = error.localizedDescription;
    }
    return errorDescription;
}

+ (NSString *)descriptionForAlfrescoError:(NSError *)error
{
    NSString *errorDescription = nil;
    
    switch (error.code)
    {
        case kAlfrescoErrorCodeHTTPResponse:
            errorDescription = NSLocalizedString(kErrorDescriptionAccessPermissions, @"SDK HTTP Response error");
            break;
            
        case kAlfrescoErrorCodeNoNetworkConnection:
            errorDescription = NSLocalizedString(kErrorDescriptionHostUnreachable, @"Host unreachable");
            break;

        case kAlfrescoErrorCodeUnauthorisedAccess:
            errorDescription = NSLocalizedString(kErrorDescriptionLoginFailed, @"Login failed");
            break;

        default:
            errorDescription = error.localizedDescription;
            break;
    }
    return errorDescription;
}

@end
