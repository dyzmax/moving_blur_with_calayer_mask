#import "UIView+ViewEffects.h"
#import "UIImage+ImageEffects.h"

@implementation UIView (ViewEffects)

-(UIImage*) generateImageFromViewiOS7API {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    if (! [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO]) {
        [NSException raise:@"failed to generate image from view" format:@"failed to generate image from view"];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return image;
}

-(UIImage*) generateImageFromViewPreiOS7API {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:ctx];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)generateBlurredImageWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    
    UIImage *image = [self generateImageFromViewPreiOS7API];
    
    image = [image applyBlurWithRadius:blurRadius
                                           tintColor:tintColor
                               saturationDeltaFactor:saturationDeltaFactor
                                           maskImage:maskImage];
    
    return image;
}

-(UIImage*) generateGausianBlurredImage {
    
    UIImage *image = [self generateImageFromViewPreiOS7API];
    
    //Blur the UIImage with a CIFilter
    CIImage *imageToBlur = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 2] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
    
    return endImage;
}

@end
