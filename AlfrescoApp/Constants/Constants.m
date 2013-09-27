//
//  Constants.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 29/07/2013
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "Constants.h"

NSInteger const kMaxItemsPerListingRetrieve = 25;

NSString * const kLicenseDictionaries = @"thirdPartyLibraries";

NSString * const kImageMappingPlist = @"ImageMapping";

// Notificiations
NSString * const kAlfrescoSessionReceivedNotification = @"AlfrescoSessionReceivedNotification";
NSString * const kAlfrescoAccessDeniedNotification = @"AlfrescoUnauthorizedAccessNotification";
NSString * const kAlfrescoApplicationPolicyUpdatedNotification = @"AlfrescoApplicationPolicyUpdatedNotification";
NSString * const kAlfrescoDocumentDownloadedNotification = @"AlfrescoDocumentDownloadedNotification";
NSString * const kAlfrescoConnectivityChangedNotification = @"AlfrescoConnectivityChangedNotification";
NSString * const kAlfrescoDocumentUpdatedOnServerNotification = @"AlfrescoDocumentUpdatedOnServerNotification";
NSString * const kAlfrescoDocumentUpdatedLocallyNotification = @"AlfrescoDocumentUpdatedLocallyNotification";
NSString * const kAlfrescoDocumentUpdatedDocumentParameterKey = @"AlfrescoDocumentUpdatedDocumentParameterKey";
NSString * const kAlfrescoDocumentUpdatedFilenameParameterKey = @"AlfrescoDocumentUpdatedFilenameParameterKey";
NSString * const kAlfrescoDocumentDownloadedIdentifierKey = @"AlfrescoDocumentDownloadedIdentifierKey";

// Application policy constants
NSString * const kApplicationPolicySettings = @"ApplicationPolicySettings";
NSString * const kApplicationPolicyAudioVideo = @"ApplicationPolicyAudioVideo";
NSString * const kApplicationPolicyServer = @"ApplicationPolicySettingServer";
NSString * const kApplicationPolicyUsernameGenerationFormat = @"ApplicationPolicySettingUsernameGenerationFormat";
NSString * const kApplicationPolicyServerDisplayName = @"ApplicationPolicySettingServerDisplayName";
NSString * const kApplicationPolicySettingAudioEnabled = @"ApplicationPolicySettingAudioEnabled";
NSString * const kApplicationPolicySettingVideoEnabled = @"ApplicationPolicySettingVideoEnabled";

// Sync
NSString * const kSyncObstaclesKey = @"syncObstacles";
NSInteger const kDefaultMaximumAllowedDownloadSize = 20 * 1024 * 1024; // 20 MB

// Sync Notification constants
NSString * const kSyncStatusChangeNotification = @"kSyncStatusChangeNotification";
NSString * const kSyncObstaclesNotification = @"kSyncObstaclesNotification";

// User settings keychain constants
NSString * const kApplicationRepositoryUsername = @"ApplictionRepositoryUsername";
NSString * const kApplicationRepositoryPassword = @"ApplictionRepositoryPassword";

// The maximum number of file suffixes that are attempted to avoid file overwrites
NSUInteger const kFileSuffixMaxAttempts = 1000;

// Custom NSError codes (use Bundle Identifier for error domain)
NSInteger const kErrorFileSuffixMaxAttempts = 101;

// Upload image quality setting
CGFloat const kUploadJPEGCompressionQuality = 1.0f;

// MultiSelect Actions
NSString * const kMultiSelectDelete = @"deleteAction";

// Thumbnail mappings folder
NSString * const kThumbnailMappingFolder = @"ThumbnailMappings";

// cache
NSInteger const kNumberOfDaysToKeepCachedData = 7;

// Good Services
NSString * const kFileTransferServiceName = @"com.good.gdservice.transfer-file";
NSString * const kFileTransferServiceVersion = @"1.0.0.0";
NSString * const kFileTransferServiceMethod = @"transferFile";
NSString * const kEditFileServiceName = @"com.good.gdservice.edit-file";
NSString * const kEditFileServiceVersion = @"1.0.0.0";
NSString * const kEditFileServiceMethod = @"editFile";
NSString * const kSaveEditFileServiceName = @"com.good.gdservice.save-edited-file";
NSString * const kSaveEditFileServiceVersion = @"1.0.0.1";
NSString * const kSaveEditFileServiceSaveEditMethod = @"saveEdit";
NSString * const kSaveEditFileServiceReleaseEditMethod = @"releaseEdit";
// keys to parameters passed to the editFile service
NSString * const kEditFileServiceParameterKey = @"identificationData"; // defined by Good Service - DO NOT CHANGE VALUE
NSString * const kEditFileServiceParameterAlfrescoDocument = @"alfrescoDocumentNode";
NSString * const kEditFileServiceParameterAlfrescoDocumentIsDownloaded = @"documentIsDownloaded";
NSString * const kEditFileServiceParameterDocumentFileName = @"documentFileName";

NSString * const kAlfrescoOnPremiseServerURLTemplate = @"http://%@:%@/alfresco";
