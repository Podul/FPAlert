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

@end

@implementation FPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIAlertController
    .alert
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
