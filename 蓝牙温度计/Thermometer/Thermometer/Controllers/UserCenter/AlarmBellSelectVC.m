//
//  AlarmBellSelectVC.m
//  Thermometer
//
//  Created by leo on 15/11/30.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AlarmBellSelectVC.h"
#import "AppSoundManager.h"
#import "ATAudioPlayManager.h"
#import "AccountStautsManager.h"

@interface AlarmBellSelectVC ()
{
    NSArray     *_soundArray;
    NSString    *_selectName;
}
@end

@implementation AlarmBellSelectVC

- (void)dealloc
{
    [[ATAudioPlayManager shardManager] stopAllAudio];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:@"确定" action:@selector(selectSound)];
    
    _soundArray = @[@"beacon",@"circuit",@"hillside",@"night",@"ring",@"senca"];
    
    [self setNavigationItemTitle:@"铃声选择"];
    [self setupTableViewWithFrame:CGRectInset(self.view.frame, 0, 0)
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.showsVerticalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectSound
{
    if ([_selectName isAbsoluteValid])
    {
        [AccountStautsManager sharedInstance].bellMp3Name = _selectName;
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectBellNotificationKey object:nil];
        [self backViewController];
    }
    else
    {
        [self showHUDInfoByString:@"请选择一个铃声"];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _soundArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.textLabel.font = kSystemFont_Size(16);
        cell.textLabel.textColor = Common_BlackColor;
    }
    cell.textLabel.text = [_soundArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectName = [_soundArray objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@.mp3",_selectName];
    [[ATAudioPlayManager shardManager] stopAllAudio];
    [[ATAudioPlayManager shardManager] playAudioNamed:name];
}


@end
