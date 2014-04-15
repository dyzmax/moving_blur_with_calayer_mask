//
//  BTCodeVC.m
//  BlurWithTimerAndMaskTest
//
//  Created by Lukasz Indyk on 4/14/14.
//  Copyright (c) 2014 Lukasz Indyk. All rights reserved.
//

#import "BTCodeVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"

@interface BTCodeVC ()

@property (nonatomic, strong) UIButton *animateButton;
@property (nonatomic, strong) UIView *nonBlurredView;
@property (nonatomic, strong) UIView *blurredView;
@property (nonatomic, strong) UIView *animatedView;

@end

@implementation BTCodeVC

#define ANIMATION_HEIGHT_DELTA 200
#define ANIMATION_DURATION 1.0f
#define PICTURE_FRAME CGRectMake(0, 80, 320, 380)
#define ANIMATED_VIEW_FRAME CGRectMake(20, 20, 280, 150)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"ala3.jpg"];
    UIImage *blurredImage = [image applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:1 alpha:0.3] saturationDeltaFactor:2 maskImage:nil];
    
    self.animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.animateButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
    [self.animateButton setTitle:@"Animate Blur View" forState:UIControlStateNormal];
    self.animateButton.frame = CGRectMake(20, 20, 150.0, 44.0);
    [self.view addSubview:self.animateButton];
    
    // 1. add non blurred view to the main view
    // 2. add blurred view to the main view
    // 3. add animated (login/password) view to the blurred view
    // 4. create mask on the blurred view showing only the animated view frame
    // 5. animate the animated view and the mask together to have an effect that the animated view blurs the non blurred view
    
    // 1
    self.nonBlurredView = [[UIView alloc] initWithFrame:PICTURE_FRAME];
    self.nonBlurredView.layer.contents = (id) image.CGImage;
    [self.view addSubview:self.nonBlurredView];
    
    // 2
    self.blurredView = [[UIView alloc] initWithFrame:PICTURE_FRAME];
    self.blurredView.layer.contents = (id) blurredImage.CGImage;
    [self.view addSubview:self.blurredView];
    
    // 3
    self.animatedView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 150)];
    [self.blurredView addSubview:self.animatedView];
    
    UITextField *login = [[UITextField alloc] initWithFrame:CGRectMake(20,20,240, 31)];
    [self setUpTextField:login enabled:NO placeholder:@"  Login" borderColor:[UIColor yellowColor] borderWidth:1.0f];
    [self.animatedView addSubview:login];
    
    UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(20,70,240, 31)];
    [self setUpTextField:password enabled:NO placeholder:@"  Password" borderColor:[UIColor blueColor] borderWidth:1.0f];
    [self.animatedView addSubview:password];
    
    // 4
    CALayer *mask = [[CALayer alloc] init];
    mask.frame = ANIMATED_VIEW_FRAME;
    mask.backgroundColor = [UIColor blackColor].CGColor; // color does not matter, alpha matters
    self.blurredView.layer.mask = mask;
}

- (void) setUpTextField:(UITextField*) textField enabled:(BOOL) enabled placeholder:(NSString*) placeholder borderColor:(UIColor*) borderColor borderWidth:(CGFloat) borderWidth {
    textField.enabled = enabled;
    textField.placeholder = placeholder;
    textField.layer.borderColor = borderColor.CGColor;
    textField.layer.borderWidth = borderWidth;
}

- (void) animate: (id) sender {
    // 5 - animate animated view in the same way like the mask layer
    CGRect origFrame = self.animatedView.frame;
    CGRect newFrame = CGRectMake(origFrame.origin.x, origFrame.origin.y + ANIMATION_HEIGHT_DELTA, origFrame.size.width, origFrame.size.height);
    CALayer *mask = self.blurredView.layer.mask;
    CGPoint origMaskPosition = mask.position;
    
    self.animateButton.enabled = NO;
    
    // 5 - the animated view
    [UIView animateWithDuration:ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        [UIView setAnimationRepeatCount:1];
        
        self.animatedView.frame = newFrame;
    } completion:^(BOOL finished) {
        self.animateButton.enabled = YES;
        self.animatedView.frame = origFrame;
        self.blurredView.layer.mask.frame = origFrame;
    }];
    
    // 5 - the mask
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,origMaskPosition.x, origMaskPosition.y);
    // line "forth and back"
    CGPathAddLineToPoint(thePath, NULL, origMaskPosition.x, origMaskPosition.y + ANIMATION_HEIGHT_DELTA);
    CGPathAddLineToPoint(thePath, NULL, origMaskPosition.x, origMaskPosition.y);
    
    CAKeyframeAnimation * theAnimation;
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=ANIMATION_DURATION * 2; // 2 times the animated view animated due to UIViewAnimationOptionAutoreverse used above
    
    [mask addAnimation:theAnimation forKey:@"position"];
}

@end
