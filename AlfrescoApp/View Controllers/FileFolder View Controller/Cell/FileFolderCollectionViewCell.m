/*******************************************************************************
 * Copyright (C) 2005-2015 Alfresco Software Limited.
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

#import "FileFolderCollectionViewCell.h"
#import "SyncNodeStatus.h"
#import "BaseLayoutAttributes.h"

static NSString * const kAlfrescoNodeCellIdentifier = @"CollectionViewCellIdentifier";

static CGFloat const kFavoriteIconWidth = 14.0f;
static CGFloat const kFavoriteIconRightSpace = 8.0f;
static CGFloat const kSyncIconWidth = 14.0f;
static CGFloat const kUpdateStatusLeadingSpace = 8.0f;
static CGFloat const kUpdateStatusContainerWidth = 36.0f;
static CGFloat const kAccessoryViewInfoWidth = 50.0f;

static CGFloat const kStatusIconsAnimationDuration = 0.2f;
static CGFloat const kStatusViewVerticalDisplacementOverImage = -40.0f;
static CGFloat const kStatusViewVerticalDisplacementSideImage = 5.0f;

@interface FileFolderCollectionViewCell ()

@property (nonatomic, strong) SyncNodeStatus *nodeStatus;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isSyncNode;
@property (nonatomic, strong) NSString *nodeDetails;

@property (nonatomic, assign) BOOL isSelectedInEditMode;
@property (nonatomic) BOOL shouldShowAccessoryView;
@property (nonatomic) BOOL statusViewIsAboveImage;

@property (nonatomic, strong) IBOutlet UIImageView *syncStatusImageView;
@property (nonatomic, strong) IBOutlet UIImageView *favoriteStatusImageView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *favoriteIconWidthConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *syncIconWidthConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *favoriteIconRightSpaceConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *syncIconRightSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateStatusViewContainerWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContentViewContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trainlingContentViewContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessoryViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingAccessoryViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *accessoryViewButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailTrailingContentViewConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodeNameLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodeNameTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewLeadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewLeadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewWidthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editImageTopSpaceConstraint;

@property (nonatomic) BOOL isEditShownBelow;
@property (nonatomic, strong) UIColor *contentBackgroundColor;

@end


@implementation FileFolderCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.contentBackgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusChanged:)
                                                 name:kSyncStatusChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddNodeToFavorites:)
                                                 name:kFavouritesDidAddNodeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRemoveNodeFromFavorites:)
                                                 name:kFavouritesDidRemoveNodeNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.image updateContentMode];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    UIColor *selectedColor = self.isSelectedInEditMode ? [UIColor selectedCollectionViewCellBackgroundColor] : [UIColor lightGrayColor];
    self.contentBackgroundColor = selected ? selectedColor : [UIColor whiteColor];
    self.content.backgroundColor = self.contentBackgroundColor;
}

- (void)updateCellInfoWithNode:(AlfrescoNode *)node nodeStatus:(SyncNodeStatus *)nodeStatus
{
    self.node = node;
    self.nodeStatus = nodeStatus;
    self.filename.text = node.name;
    [self updateNodeDetails:nodeStatus];
}

- (void)updateStatusIconsIsSyncNode:(BOOL)isSyncNode isFavoriteNode:(BOOL)isFavorite animate:(BOOL)animate
{
    self.isSyncNode = isSyncNode;
    self.isFavorite = isFavorite;
    
    self.syncStatusImageView.image = nil;
    self.syncStatusImageView.highlightedImage = nil;
    self.favoriteStatusImageView.image = nil;
    self.favoriteStatusImageView.highlightedImage = nil;
    
    void (^updateStatusIcons)(void) = ^{
        
        CGFloat updateContainerWidth = kUpdateStatusContainerWidth;
        if (self.isFavorite)
        {
            self.favoriteStatusImageView.image = [UIImage imageNamed:@"status-favourite.png"];
            self.favoriteStatusImageView.highlightedImage = [UIImage imageNamed:@"status-favourite-highlighted.png"];
            
            self.favoriteIconWidthConstraint.constant = kFavoriteIconWidth;
            self.favoriteIconRightSpaceConstraint.constant = kFavoriteIconRightSpace;
        }
        else
        {
            self.favoriteIconWidthConstraint.constant = 0;
            self.favoriteIconRightSpaceConstraint.constant = 0;
            updateContainerWidth = updateContainerWidth - kFavoriteIconWidth - kFavoriteIconRightSpace;
        }
        
        if (self.isSyncNode)
        {
            self.syncIconWidthConstraint.constant = kSyncIconWidth;
        }
        else
        {
            self.syncIconWidthConstraint.constant = 0;
            self.favoriteIconRightSpaceConstraint.constant = 0;
            updateContainerWidth = updateContainerWidth - kSyncIconWidth - kFavoriteIconRightSpace;
        }
        
        if(updateContainerWidth < 0.0f)
        {
            updateContainerWidth = 0.0f;
        }
        
        self.updateStatusViewContainerWidthConstraint.constant = updateContainerWidth;
        
        if(self.statusViewIsAboveImage)
        {
            self.statusViewLeadingContraint.constant = - self.updateStatusViewContainerWidthConstraint.constant;
        }
        else
        {
            self.statusViewLeadingContraint.constant = kUpdateStatusLeadingSpace;
        }
        
        [self layoutIfNeeded];
    };
    
    if (animate)
    {
        [UIView animateWithDuration:kStatusIconsAnimationDuration animations:^{
            updateStatusIcons();
        }];
    }
    else
    {
        updateStatusIcons();
    }
    
    [self updateCellWithNodeStatus:self.nodeStatus propertyChanged:kSyncStatus];
}

+ (NSString *)cellIdentifier
{
    return kAlfrescoNodeCellIdentifier;
}

- (void)showDeleteAction:(BOOL)showDelete animated:(BOOL)animated
{
    double shiftAmount;
    if(showDelete)
    {
        shiftAmount = self.actionsViewWidthContraint.constant;
    }
    else
    {
        shiftAmount = 0.0;
    }
    
    [self layoutIfNeeded];
    self.leadingContentViewContraint.constant = -shiftAmount;
    self.trainlingContentViewContraint.constant = shiftAmount;
    
    if(animated)
    {
        [UIView animateWithDuration:0.40 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    }
    else
    {
        [self layoutIfNeeded];
    }
}

- (void)revealActionViewWithAmount:(CGFloat)amount
{
    [self layoutIfNeeded];
    self.leadingContentViewContraint.constant = amount;
    if(self.leadingContentViewContraint.constant > 0.0f)
    {
        self.leadingContentViewContraint.constant = 0.0f;
    }
    self.trainlingContentViewContraint.constant = -amount;
    if(self.trainlingContentViewContraint.constant < 0.0f)
    {
        self.trainlingContentViewContraint.constant = 0.0f;
    }
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)resetView
{
    [self layoutIfNeeded];
    self.leadingContentViewContraint.constant = 0.0;
    self.trainlingContentViewContraint.constant = 0.0;
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)showEditMode:(BOOL)showEdit selected:(BOOL)isSelected animated:(BOOL)animated
{
    if(self.isEditShownBelow)
    {
        [self.contentView bringSubviewToFront:self.content];
        double shiftAmount;
        if(showEdit)
        {
            shiftAmount = self.editViewWidthContraint.constant;
        }
        else
        {
            shiftAmount = 0.0f;
        }
        
        [self wasSelectedInEditMode:isSelected];
        [self layoutIfNeeded];
        self.leadingContentViewContraint.constant = shiftAmount;
        self.trainlingContentViewContraint.constant = -shiftAmount;
    }
    else
    {
        if(animated)
        {
            [self.contentView bringSubviewToFront:self.editView];
        }
        double shiftAmount;
        if(showEdit)
        {
            shiftAmount = 0.0f;
        }
        else
        {
            shiftAmount = -self.editViewWidthContraint.constant;
        }
        
        [self wasSelectedInEditMode:isSelected];
        [self layoutIfNeeded];
        self.editViewLeadingContraint.constant = shiftAmount;
    }
    
    if(animated)
    {
        [UIView animateWithDuration:0.40 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    }
    else
    {
        [self layoutIfNeeded];
    }
}

- (void) showEditMode:(BOOL)showEdit animated:(BOOL)animated
{
    [self showEditMode:showEdit selected:NO animated:animated];
}

- (void) wasSelectedInEditMode:(BOOL)wasSelected
{
    self.isSelectedInEditMode = wasSelected;
    if(wasSelected)
    {
        [self.editImageView setImage:[[UIImage imageNamed:@"cell-button-checked-filled.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.editImageView.tintColor = [UIColor appTintColor];
        self.content.backgroundColor = [UIColor selectedCollectionViewCellBackgroundColor];
        self.contentView.backgroundColor = [UIColor selectedCollectionViewCellBackgroundColor];
    }
    else
    {
        [self.editImageView setImage:[UIImage imageNamed:@"cell-button-unchecked.png"]];
        self.content.backgroundColor = self.contentBackgroundColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Notification Methods

- (void)statusChanged:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    if ([self.node.identifier hasPrefix:[info objectForKey:kSyncStatusNodeIdKey]])
    {
        SyncNodeStatus *nodeStatus = notification.object;
        self.nodeStatus = nodeStatus;
        NSString *propertyChanged = [info objectForKey:kSyncStatusPropertyChangedKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.isSyncNode && nodeStatus.status != SyncStatusRemoved)
            {
                [self updateStatusIconsIsSyncNode:YES isFavoriteNode:self.isFavorite animate:YES];
            }
            if (nodeStatus.status == SyncStatusRemoved)
            {
                self.nodeStatus = nil;
                [self updateStatusIconsIsSyncNode:NO isFavoriteNode:self.isFavorite animate:YES];
            }
            [self updateCellWithNodeStatus:nodeStatus propertyChanged:propertyChanged];
        });
    }
}

- (void)didAddNodeToFavorites:(NSNotification *)notification
{
    AlfrescoNode *nodeFavorited = (AlfrescoNode *)notification.object;
    if ([nodeFavorited.identifier isEqualToString:self.node.identifier])
    {
        [self updateStatusIconsIsSyncNode:self.isSyncNode isFavoriteNode:YES animate:YES];
    }
}

- (void)didRemoveNodeFromFavorites:(NSNotification *)notification
{
    AlfrescoNode *nodeUnFavorited = (AlfrescoNode *)notification.object;
    if ([nodeUnFavorited.identifier isEqualToString:self.node.identifier])
    {
        self.isFavorite = NO;
        [self updateStatusIconsIsSyncNode:self.isSyncNode isFavoriteNode:NO animate:YES];
    }
}

#pragma mark - Private Methods

- (void)updateCellWithNodeStatus:(SyncNodeStatus *)nodeStatus propertyChanged:(NSString *)propertyChanged
{
    if ([propertyChanged isEqualToString:kSyncStatus])
    {
        [self setAccessoryViewForState:nodeStatus.status];
        [self updateSyncStatusDetails:nodeStatus];
    }
    else if ([propertyChanged isEqualToString:kSyncTotalSize] || [propertyChanged isEqualToString:kSyncLocalModificationDate])
    {
        [self updateNodeDetails:nodeStatus];
    }
    
    if(self.isSyncNode)
    {
        [self updateStatusImageForSyncState:nodeStatus];
    }
    
    if (nodeStatus.status == SyncStatusLoading && nodeStatus.bytesTransfered > 0 && nodeStatus.bytesTransfered < nodeStatus.totalBytesToTransfer)
    {
        self.progressBar.hidden = NO;
        float percentTransfered = (float)nodeStatus.bytesTransfered / (float)nodeStatus.totalBytesToTransfer;
        self.progressBar.progress = percentTransfered;
    }
    else
    {
        self.progressBar.hidden = YES;
    }
}

- (void)updateStatusImageForSyncState:(SyncNodeStatus *)nodeStatus
{
    NSString *statusImageName = nil;
    switch (nodeStatus.status)
    {
        case SyncStatusCancelled:
        case SyncStatusFailed:
            statusImageName = @"status-sync-failed";
            break;
            
        case SyncStatusLoading:
            statusImageName = @"status-sync-loading";
            break;
            
        case SyncStatusOffline:
        case SyncStatusDisabled:
        case SyncStatusWaiting:
            statusImageName = @"status-sync-waiting";
            break;
            
        case SyncStatusSuccessful:
            statusImageName = @"status-sync-synced";
            break;
            
        default:
            break;
    }
    
    if (statusImageName)
    {
        self.syncStatusImageView.image = [UIImage imageNamed:statusImageName];
        self.syncStatusImageView.highlightedImage = [UIImage imageNamed:[statusImageName stringByAppendingString:@"-highlighted"]];
    }
}

- (void)setAccessoryViewForState:(SyncStatus)status
{
    if(self.shouldShowAccessoryView)
    {
        [self layoutIfNeeded];
        if (self.node.isFolder)
        {
            UIImage *buttonImage = [[UIImage imageNamed:@"cell-button-info.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.accessoryViewButton.tintColor = [UIColor appTintColor];
            [self.accessoryViewButton setTitle:@"" forState:UIControlStateNormal];
            [self.accessoryViewButton setImage:buttonImage forState:UIControlStateNormal];
            [self.accessoryViewButton setShowsTouchWhenHighlighted:YES];
            [self.accessoryViewButton addTarget:self action:@selector(accessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.accessoryViewWidthConstraint.constant = kAccessoryViewInfoWidth;
        }
        else
        {
            UIImage *buttonImage;
            
            switch (status)
            {
                case SyncStatusLoading:
                    buttonImage = [[UIImage imageNamed:@"sync-button-stop.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [self.accessoryViewButton setTitle:@"" forState:UIControlStateNormal];
                    self.accessoryViewButton.tintColor = [UIColor appTintColor];
                    break;
                    
                case SyncStatusFailed:
                    buttonImage = [[UIImage imageNamed:@"sync-button-error.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [self.accessoryViewButton setTitle:@"" forState:UIControlStateNormal];
                    self.accessoryViewButton.tintColor = [UIColor syncFailedColor];
                    break;
                    
                default:
                    self.accessoryViewWidthConstraint.constant = 0.0;
                    break;
            }
            
            if (buttonImage)
            {
                [self.accessoryViewButton setImage:buttonImage forState:UIControlStateNormal];
                [self.accessoryViewButton setShowsTouchWhenHighlighted:YES];
                [self.accessoryViewButton addTarget:self action:@selector(accessoryButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                self.accessoryViewWidthConstraint.constant = buttonImage.size.width;
            }
        }
        [self layoutIfNeeded];
    }
}

- (void)updateNodeDetails:(SyncNodeStatus *)nodeStatus
{
    NSString *fileSizeString = nil;
    NSString *modifiedDateString = nil;
    
    if (self.node.isFolder)
    {
        if (nodeStatus.totalSize > 0)
        {
            fileSizeString = stringForLongFileSize(nodeStatus.totalSize);
            self.nodeDetails = fileSizeString;
        }
        else
        {
            self.nodeDetails = @"";
        }
    }
    else
    {
        modifiedDateString = nodeStatus.localModificationDate ? relativeTimeFromDate(nodeStatus.localModificationDate) : relativeTimeFromDate(self.node.modifiedAt);
        fileSizeString = (nodeStatus.totalSize > 0) ? stringForLongFileSize(nodeStatus.totalSize) : stringForLongFileSize(((AlfrescoDocument *)self.node).contentLength);
        self.nodeDetails = [NSString stringWithFormat:@"%@ • %@", modifiedDateString, fileSizeString];
    }
    
    [self updateSyncStatusDetails:nodeStatus];
}

- (void)updateSyncStatusDetails:(SyncNodeStatus *)nodeStatus
{
    self.details.textColor = [UIColor textDefaultColor];
    
    if (nodeStatus.status == SyncStatusWaiting)
    {
        self.details.text = NSLocalizedString(@"sync.state.waiting-to-sync", @"waiting to sync");
    }
    else if (nodeStatus.status == SyncStatusFailed)
    {
        self.details.text = NSLocalizedString(@"sync.state.failed-to-sync", @"failed to sync");
        self.details.textColor = [UIColor syncFailedColor];
    }
    else
    {
        self.details.text = self.nodeDetails;
    }
}

#pragma mark - Overriden methods
- (void)applyLayoutAttributes:(BaseLayoutAttributes *)layoutAttributes
{
    [self layoutIfNeeded];
    
    self.nodeNameLeadingConstraint.constant = layoutAttributes.nodeNameHorizontalDisplacement;
    self.nodeNameTopSpaceConstraint.constant = layoutAttributes.nodeNameVerticalDisplacement;
    self.thumbnailTrailingContentViewConstant.constant = layoutAttributes.thumbnailContentTrailingSpace;
    
    if([self.node isKindOfClass:[AlfrescoFolder class]])
    {
        if(layoutAttributes.shouldShowSmallThumbnailImage)
        {
            [self.image setImage:smallImageForType(@"folder") withFade:NO];
        }
        else
        {
            [self.image setImage:largeImageForType(@"folder") withFade:NO];
        }
    }
    
    self.separatorHeightConstraint.constant = layoutAttributes.shouldShowSeparatorView ? 1/[[UIScreen mainScreen] scale] : 0.0f;
    self.content.layer.borderWidth = layoutAttributes.shouldShowSeparatorView ? 0.0f : 1/[[UIScreen mainScreen] scale];
    self.content.layer.borderColor = [[UIColor borderGreyColor] CGColor];
    
    self.filename.textAlignment = layoutAttributes.filenameAligment;
    
    self.details.hidden = !layoutAttributes.shouldShowNodeDetails;
    self.filename.font = layoutAttributes.nodeNameFont;
    if(!layoutAttributes.shouldShowAccessoryView)
    {
        self.accessoryViewWidthConstraint.constant = 0.0f;
        self.shouldShowAccessoryView = NO;
    }
    else
    {
        self.shouldShowAccessoryView = YES;
    }
    
    if(layoutAttributes.shouldShowStatusViewOverImage)
    {
        self.statusViewLeadingContraint.constant = - self.updateStatusViewContainerWidthConstraint.constant;
        self.statusViewTopConstraint.constant = kStatusViewVerticalDisplacementOverImage;
    }
    else
    {
        self.statusViewLeadingContraint.constant = kUpdateStatusLeadingSpace;
        self.statusViewTopConstraint.constant = kStatusViewVerticalDisplacementSideImage;
    }
    self.statusViewIsAboveImage = layoutAttributes.shouldShowStatusViewOverImage;
    
    self.editImageTopSpaceConstraint.constant = layoutAttributes.editImageTopSpace;
    
    self.editViewLeadingContraint.constant = layoutAttributes.shouldShowEditBelowContent ? 0.0f : -self.editViewWidthContraint.constant;
    self.isEditShownBelow = layoutAttributes.shouldShowEditBelowContent;
    
    if(self.isEditShownBelow)
    {
        [self.contentView bringSubviewToFront:self.content];
    }
    else if(layoutAttributes.animated)
    {
        [self.contentView bringSubviewToFront:self.editView];
    }
    
    [self updateStatusIconsIsSyncNode:self.isSyncNode isFavoriteNode:self.isFavorite animate:NO];
    
    [self layoutIfNeeded];
    
    if(!layoutAttributes.isEditing)
    {
        [self showDeleteAction:layoutAttributes.showDeleteButton animated:layoutAttributes.animated];
    }
    else
    {
        [self showEditMode:layoutAttributes.isEditing selected:layoutAttributes.isSelectedInEditMode animated:layoutAttributes.animated];
    }
    
    [self.image updateContentMode];
}

#pragma mark - Private Methods

- (void)accessoryButtonTapped:(UIControl *)button withEvent:(UIEvent *)event
{
    [self.accessoryViewDelegate didTapCollectionViewCellAccessorryView:self.node];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end