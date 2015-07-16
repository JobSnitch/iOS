//
//  EmployeeSearchViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeSearchViewController.h"
#import "EmployeeRecord.h"

@interface EmployeeSearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *oBackImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oWidthConstraint;
@property (weak, nonatomic) IBOutlet UISlider *oProxySlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;
@property (weak, nonatomic) IBOutlet UIButton *oIndustryButton;
@property (weak, nonatomic) IBOutlet UIButton *oJobTypeButton;
@property (weak, nonatomic) IBOutlet UITableView *oJobTypeTable;
@property (weak, nonatomic) IBOutlet UITableView *oIndustryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oJobTypeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oIndustryHeightConstraint;

@property (nonatomic, strong)   UILabel * sliderLabel;
@property (nonatomic, strong)   NSMutableArray *currentJobTypes;
@property (nonatomic, strong)   NSMutableArray *currentIndustries;
@end

const float kMagicHeightS = 595.0;

@implementation EmployeeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmployee];
    
    [self setupEmployeeView];
    [self setupTables];
    [self setupSlider];

    [super setupJobtypePicker];
    [super setupIndustryPicker];
    self.currentJobTypes = [[NSMutableArray alloc] init];
    self.currentIndustries = [[NSMutableArray alloc] init];

}

-(void) viewDidAppear:(BOOL)animated {
    [self sliderAction2:self.oProxySlider];
}

-(void) viewDidLayoutSubviews {
    [self.employeeHeaderView layoutFields:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.employeeHeaderView setFrame:self.view.frame];
    
    self.oWidthConstraint.constant = self.view.bounds.size.width-20.0;
    if (self.currentJobTypes && self.currentJobTypes.count) {
        self.oJobTypeHeightConstraint.constant = self.currentJobTypes.count * [self tableView:self.oJobTypeTable heightForRowAtIndexPath:0];
    }
    if (self.currentIndustries && self.currentIndustries.count) {
        self.oIndustryHeightConstraint.constant = self.currentIndustries.count * [self tableView:self.oIndustryTable heightForRowAtIndexPath:0];
    }
    self.oHeightConstraint.constant = kMagicHeightS + self.oJobTypeHeightConstraint.constant + self.oIndustryHeightConstraint.constant;
    [self.view bringSubviewToFront:self.oBackImage];
    [self.view bringSubviewToFront:self.oScrollView];
    
    [super bringPickersToFront];

    [self.view layoutIfNeeded];
}

-(void) setupTables {
    self.oJobTypeTable.delegate = self;
    self.oJobTypeTable.dataSource = self;
    
    self.oIndustryTable.delegate = self;
    self.oIndustryTable.dataSource = self;
    
}

#pragma mark - interface
-(void) setupEmployeeView {
    [super setupEmployeeView];
    
    [self setupHeader];
}

-(void) setupHeader {
    self.employeeHeaderView.oTopImage.image = [UIImage imageNamed:self.currentEmployee.imageName];
    self.employeeHeaderView.oNameLabel.text = self.currentEmployee.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.employeeHeaderView.oTopImage.image = avatarImage;
    }
}

#pragma mark - actions
- (IBAction)actionAddJobType:(id)sender {
    [super showJobtypePicker];
}

- (IBAction)actionAddIndustry:(id)sender {
    [super showIndustryPicker];
}

- (IBAction)actionUpdateSearch:(id)sender {
}

#pragma mark - slider
-(void) setupSlider {
    [self.oProxySlider addTarget:self action:@selector(sliderAction1:) forControlEvents:UIControlEventValueChanged];
    [self.oProxySlider addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.oProxySlider addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventTouchUpOutside];
    self.oProxySlider.minimumValue = 0.0;
    self.oProxySlider.maximumValue = 1.0;
    self.oProxySlider.continuous = YES;
    self.oProxySlider.value = 0.5;
    
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.sliderLabel setBackgroundColor:[UIColor clearColor]];
    [self.sliderLabel setTextAlignment:NSTextAlignmentCenter];
    [self.oProxySlider addSubview:self.sliderLabel];
    
}

-(void) sliderAction1:(id)sender {
    [self updateLabel];
}

-(void) sliderAction2:(id)sender {
    float roundVal = 0.0;
    NSString *text = @"";
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Black" size:9],
                                     NSForegroundColorAttributeName: [UIColor redColor]};
    
    if (self.oProxySlider.value < 0.2) {
        roundVal = 0.1;
        text = @"2km";
    } else if (self.oProxySlider.value < 0.4) {
        roundVal = 0.3;
        text = @"5km";
    } else if (self.oProxySlider.value < 0.6) {
        roundVal = 0.5;
        text = @"10km";
    } else if (self.oProxySlider.value < 0.8) {
        roundVal = 0.7;
        text = @"15km";
    } else {
        roundVal = 0.9;
        text = @"20km";
    }
    [self.oProxySlider setValue:roundVal animated:YES];
    self.sliderLabel.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                      attributes:text1Attribute];
    [self updateLabel];
}

-(void) updateLabel {
    CGRect trackRect = [self.oProxySlider trackRectForBounds:self.oProxySlider.bounds];
    CGRect thumbRect = [self.oProxySlider thumbRectForBounds:self.oProxySlider.bounds trackRect:trackRect
                                                       value:self.oProxySlider.value];
    self.sliderLabel.center = CGPointMake(thumbRect.origin.x + thumbRect.size.width*0.5,  thumbRect.origin.y + thumbRect.size.height*0.5);
    [self.oProxySlider bringSubviewToFront:self.sliderLabel];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.oJobTypeTable) {
        if (self.currentJobTypes) {
            return self.currentJobTypes.count;
        } else {
            return 0;
        }
    } else {
        if (self.currentIndustries) {
            return self.currentIndustries.count;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=nil;
    if (tableView == self.oJobTypeTable) {
        if (!self.currentJobTypes || !(indexPath.row < self.currentJobTypes.count)) {
            return cell;
        }
    } else {
        if (!self.currentIndustries || !(indexPath.row < self.currentIndustries.count)){
            return cell;
        }
    }
    static NSString *CellIdentifier = @"EmpSearchTableID";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        NSArray* contentSubViews = [cell.contentView subviews];
        for (UIView* viewToRemove in contentSubViews)
        {
            [viewToRemove removeFromSuperview];
        }
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                     NSForegroundColorAttributeName: [UIColor redColor]};
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 19.0f, 200.0f, 18.0f)];
    [cell.contentView addSubview:l1];
    l1.textAlignment = NSTextAlignmentLeft;
    NSString *content = nil;
    if (tableView == self.oJobTypeTable) {
        content = self.currentJobTypes[indexPath.row];
    } else {
        content = self.currentIndustries[indexPath.row];
    }
    
    l1.attributedText = [[NSAttributedString alloc] initWithString:content
                                                        attributes:text1Attribute];
    return cell;
}

#pragma mark - overwrite

-(void) refreshScreen {
    if (super.pickerSelectionJT) {
        [self.currentJobTypes addObject:super.pickerSelectionJT];
        [self.oJobTypeTable reloadData];
    }
    if (super.pickerSelectionI) {
        [self.currentIndustries addObject:super.pickerSelectionI];
        [self.oIndustryTable reloadData];
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
