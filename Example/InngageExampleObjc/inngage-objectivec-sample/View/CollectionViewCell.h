//
//  CollectionViewCell.h
//  inngage-objectivec-sample
//
//  Created by TQI on 24/04/17.
//  Copyright © 2017 Luis Teodoro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnKnowMoew;

- (IBAction)btnFacebook:(id)sender;
- (IBAction)btnLinkedin:(id)sender;
- (IBAction)btnKnowMoew:(id)sender;

@end
