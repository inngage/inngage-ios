//
//  CollectionViewCell.m
//  inngage-objectivec-sample
//
//  Created by TQI on 24/04/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnKnowMoew.layer.masksToBounds = YES;
    self.btnKnowMoew.layer.cornerRadius = 5.0;
}

- (IBAction)btnFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/inngage"]];

}

- (IBAction)btnLinkedin:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.linkedin.com/company-beta/10618473/?pathWildcard=10618473"]];

}

- (IBAction)btnKnowMoew:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://inngage.com.br"]];

}
@end
