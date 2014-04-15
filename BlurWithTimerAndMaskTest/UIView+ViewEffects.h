#import <UIKit/UIKit.h>

@interface UIView (ViewEffects)

-(UIImage *)generateBlurredImageWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
-(UIImage*) generateGausianBlurredImage;

@end
