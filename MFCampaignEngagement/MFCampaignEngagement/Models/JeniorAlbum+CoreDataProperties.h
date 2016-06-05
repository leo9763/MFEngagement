//
//  JeniorAlbum+CoreDataProperties.h
//  MFCampaignEngagement
//
//  Created by nero on 6/4/16.
//  Copyright © 2016 MingFung. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JeniorAlbum.h"

NS_ASSUME_NONNULL_BEGIN

@interface JeniorAlbum (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *area;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) id photos;
@property (nonatomic, assign) BOOL isExpend;
@property (nullable, nonatomic, retain) NSString *coverImage;

@end

NS_ASSUME_NONNULL_END
