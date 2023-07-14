//
//  OpenCVWrapper.h
//  Hackathon
//
//  Created by 周亮 on 2023/7/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (UIImage *)cannyEdgeDetection:(UIImage *)input;

@end


NS_ASSUME_NONNULL_END
