//
//  OpenCVWrapper.m
//  Hackathon
//
//  Created by 周亮 on 2023/7/14.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper

+ (UIImage *)cannyEdgeDetection:(UIImage *)input {
    cv::Mat mat;
    UIImageToMat(input, mat);

    cv::Mat gray, edges;
    cv::cvtColor(mat, gray, cv::COLOR_BGR2GRAY);
    cv::Canny(gray, edges, 50, 150);

    UIImage *output = MatToUIImage(edges);
    return output;
}

@end
