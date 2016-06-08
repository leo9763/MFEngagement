//
//  MFImageHelper.m
//  MFCampaignEngagement
//
//  Created by nero on 6/7/16.
//  Copyright © 2016 MingFung. All rights reserved.
//

#import "MFImageHelper.h"

@implementation MFImageHelper

+ (void)adaptImageView:(UIImageView *)imageView withImage:(UIImage *)image
{
    CGSize ovs = imageView.frame.size;
    CGRect tvr = imageView.frame;
    CGSize is = image.size;
    
    if (ovs.width > is.width && ovs.height > is.height) {
        tvr.size.width = is.width;
        tvr.size.height = is.height;
    } else if (ovs.width < is.width && ovs.height < is.height) {
        tvr.size.height = ovs.width * is.height/is.width;
        tvr.size.width = ovs.width;
        if (tvr.size.height > ovs.height) {
            tvr.size.width = ovs.height * is.width/is.height;
            tvr.size.height = ovs.height;
        }
    } else if (ovs.width < is.width) {
        tvr.size.height = ovs.width * is.height/is.width;
        tvr.size.width = ovs.width;
    } else if (ovs.height < is.height) {
        tvr.size.width = ovs.height * is.width/is.height;
        tvr.size.height = ovs.height;
    }
    
    imageView.frame = tvr;
}

@end
