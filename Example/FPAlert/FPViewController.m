//
//  FPViewController.m
//  FPAlert
//
//  Created by Podul on 11/09/2019.
//  Copyright (c) 2019 Podul. All rights reserved.
//

#import "FPViewController.h"
#import <FPAlert.h>

@interface FPViewController ()
@property (nonatomic, strong) UIView *aView;
@end

@implementation FPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _aView.backgroundColor = UIColor.redColor;
    [self.view addSubview:_aView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self
    .actionSheet(_aView, _aView.bounds)
    .title(@"title")
    .message(@"message")
    .cancel(@"Cancel", ^(UIAlertAction *action) {
        NSLog(@"touched Cancel");
    })
    .action(@"Default1", ^(UIAlertAction *action) {
        NSLog(@"touched Default");
    })
    .destructive(@"Destructive", ^(UIAlertAction *action) {
        NSLog(@"touched Destructive");
    })
    .action(@"Default2", nil)
    .show();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
