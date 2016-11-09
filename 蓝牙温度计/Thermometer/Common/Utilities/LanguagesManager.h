//
//  LanguagesManager.h
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBCConvertor.h"

#define LocalizedStr(key) [LanguagesManager getStr:key]

static NSString * const SimpleChinese       = @"zh-Hans";
static NSString * const TradictionalChinese = @"zh-Hant";
static NSString * const English             = @"en";

static NSString * const LanguageTypeDidChangedNotificationKey = @"LanguageTypeDidChangedNotificationKey";

@interface LanguagesManager : NSObject

+ (void)initialize;
+ (NSArray *)getAppLanguagesTypeArray;
+ (void)setLanguage:(NSString *)languageType;
+ (NSString *)curLanguagesType;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate;

////////////////////////////////////////////////////////////////////////////////

/// 把str转换为当前语言类型的字符串(只支持简体<->繁体)
+ (NSString *)getCurLanguagesTypeStrWithStr:(NSString *)str;

@end

// 所有模块
static NSString * const All_DataSourceNotFoundKey  = @"All_DataSourceNotFound";
static NSString * const All_Delete                 = @"All_Delete";
static NSString * const All_Check                  = @"All_Check";
static NSString * const All_Confirm                = @"All_Confirm";
static NSString * const All_Cancel                 = @"All_Cancel";
static NSString * const All_PickFromCamera         = @"All_PickFromCamera";
static NSString * const All_PickFromAlbum          = @"All_PickFromAlbum";
static NSString * const All_SaveToAlbum            = @"All_SaveToAlbum";
static NSString * const All_SaveSuccess            = @"All_SaveSuccess";
static NSString * const All_OperationFailure       = @"All_OperationFailure";
static NSString * const All_Notification           = @"All_Notification";

// 其他

// 搜索页

// 版本检测

// 各控制器导航栏标题

////////////////////////////////////////////////////////////////////////////

static NSString * const yushi = @"yushi";
static NSString * const has_copy_yushi = @"has_copy_yushi";
static NSString * const tem_set_err_notice = @"tem_set_err_notice";
static NSString * const clear_default_device = @"clear_default_device";
static NSString * const clear_default_device_notice = @"clear_default_device_notice";
static NSString * const input_password_notice = @"input_password_notice";
static NSString * const input_password_again_notice = @"input_password_again_notice";
static NSString * const set_password = @"set_password";
static NSString * const input_new_password = @"input_new_password";
static NSString * const input_new_password_again = @"input_new_password_again";
static NSString * const quit_password_set_notice = @"quit_password_set_notice";
static NSString * const please_add_member = @"please_add_member";
static NSString * const please_choose_ring = @"please_choose_ring";
static NSString * const please_choose_gender = @"please_choose_gender";
static NSString * const please_enter_age = @"please_enter_age";
static NSString * const please_choose_member_type = @"please_choose_member_type";

////////////////////////////////////////////////////////////////////////////

static NSString * const company = @"company";
static NSString * const soft_version = @"soft_version";
static NSString * const soft_help = @"soft_help";
static NSString * const concern_us = @"concern_us";

static NSString * const enter_nickname = @"enter_nickname";
static NSString * const gender = @"gender";
static NSString * const age = @"age";
static NSString * const male = @"male";
static NSString * const female = @"female";
static NSString * const family_role = @"family_role" ;
static NSString * const baby = @"baby";
static NSString * const register_ = @"register";
static NSString * const login = @"login";
static NSString * const guest_mode = @"guest_mode";
static NSString * const mobile_phone_no = @"mobile_phone_no.";
static NSString * const your_mobile_phone_no = @"your_mobile_phone_no.";
static NSString * const password = @"password";
static NSString * const password__ = @"password__";
static NSString * const forgot_password = @"forgot_password";
static NSString * const create_an_account = @"create_an_account";
static NSString * const fill_password = @"fill_password";
static NSString * const fill_password_again = @"fill_password_again";
static NSString * const log_out = @"log_out";
static NSString * const verify_via_SMS = @"verify_via_SMS";
static NSString * const please_add_user = @"please_add_user";
static NSString * const member_managed = @"member_managed";
static NSString * const add_member = @"add_member";

static NSString * const alarm_options = @"alarm_options";
static NSString * const temp_alarm = @"temp_alarm";
static NSString * const unconnect_alarm = @"unconnect_alarm";
static NSString * const alarm_mode = @"alarm_mode";
static NSString * const alarm_ring = @"alarm_ring";
static NSString * const alarm_vibrating = @"alarm_vibrating";
static NSString * const ring_setting = @"ring_setting";
static NSString * const temp_setting = @"temp_setting";

static NSString * const done = @"done";
static NSString * const mac = @"mac";
static NSString * const unconnec_device = @"unconnec_device";

static NSString * const temperature_anomaly = @"temperature_anomaly";
static NSString * const attention_please = @"attention_please";
static NSString * const alarm_setting = @"alarm_setting";
static NSString * const history = @"history";
static NSString * const data_sync = @"data_sync";
static NSString * const toggle_units = @"toggle_units";

static NSString * const highest_temp = @"highest_temp";
static NSString * const lowest_temp = @"lowest_temp";
static NSString * const highest_temp__ = @"highest_temp__";
static NSString * const device = @"device";
static NSString * const bluetooth = @"bluetooth";
static NSString * const not_open = @"not_open";
static NSString * const connect_BLE = @"connect_BLE";
static NSString * const remote_monitor = @"remote_monitor";
static NSString * const select_mode = @"select_mode";

static NSString * const setting = @"setting";
static NSString * const about = @"about";
static NSString * const app_name = @"app_name";
static NSString * const searching = @"searching";
static NSString * const unconnect = @"unconnect";
static NSString * const unsupport = @"unsupport";

static NSString * const temp_high = @"temp_high";
static NSString * const temp_low__ = @"temp_low__";
static NSString * const temp_low = @"temp_low";
static NSString * const temp_normal = @"temp_normal";
static NSString * const low_fever = @"low_fever";
static NSString * const high_fever = @"high_fever";
static NSString * const temp_exception = @"temp_exception";
static NSString * const temp_low_tips = @"temp_low_tips";
static NSString * const temp_high_tips = @"temp_high_tips";
static NSString * const disconnect_tips = @"disconnect_tips";
static NSString * const soft_update_no = @"soft_update_no";
static NSString * const soft_update_title = @"soft_update_title";
static NSString * const soft_update_info = @"soft_update_info";
static NSString * const soft_ok = @"soft_ok";
static NSString * const soft_cancel = @"soft_cancel";
static NSString * const soft_updating = @"soft_updating";

static NSString * const open_network = @"open_network";
static NSString * const synchronizing = @"synchronizing";
static NSString * const connecting = @"connecting";
static NSString * const remind_me_after = @"remind_me_after";
static NSString * const remind_me_after_20 = @"remind_me_after_20";
static NSString * const remind_me_after_30 = @"remind_me_after_30";
static NSString * const disconnect_until = @"disconnect_until";
static NSString * const concern_us_tip = @"concern_us_tip";
static NSString * const loading = @"loading";
static NSString * const account_info = @"account_info";
static NSString * const take_photo = @"take_photo";
static NSString * const insert_sdcard = @"insert_sdcard";
static NSString * const from_gallery = @"from_gallery";
static NSString * const no_memery_card = @"no_memery_card";
static NSString * const age_error = @"age_error";
static NSString * const network_abnormal = @"network_abnormal";
static NSString * const add_success = @"add_success";
static NSString * const user_exist = @"user_exist";
static NSString * const add_failed = @"add_failed";
static NSString * const modify_failed = @"modify_failed";
static NSString * const modify_success = @"modify_success";
static NSString * const temp_max_too_high = @"temp_max_too_high";
static NSString * const user_exist_act = @"user_exist_act";
static NSString * const http_error = @"http_error";
static NSString * const fill_error = @"fill_error";
static NSString * const login_success = @"login_success";
static NSString * const user_not_exist = @"user_not_exist";
static NSString * const user_not_exist_act = @"user_not_exist_act";
static NSString * const phone_pw_error = @"phone_pw_error";
static NSString * const press_again_no_alarm = @"press_again_no_alarm";
static NSString * const reset_password = @"reset_password";
static NSString * const new_password = @"new_password";
static NSString * const password_not_match = @"password_not_match";
static NSString * const register_success = @"register_success";
static NSString * const phone_exist = @"phone_exist";
static NSString * const register_error = @"register_error";
static NSString * const phone_no_exist = @"phone_no_exist";
static NSString * const please_login = @"please_login";
static NSString * const change_user = @"change_user";
static NSString * const change = @"change";
static NSString * const delete_unrecoverable = @"delete_unrecoverable";
static NSString * const change_user_before_delete = @"change_user_before_delete";
static NSString * const delete_success = @"delete_success";
static NSString * const member_no_exist = @"member_no_exist";
static NSString * const delete_failed = @"delete_failed";
static NSString * const application_error = @"application_error";
static NSString * const find_thermometer = @"find_thermometer";
static NSString * const search_again = @"search_again";
static NSString * const not_find_default = @"not_find_default";
static NSString * const set_default_device = @"set_default_device";

static NSString * const device_cache_tip = @"device_cache_tip";
static NSString * const clear_ = @"clear";
static NSString * const save = @"save";

static NSString * const update_running = @"update_running";
static NSString * const lastest_version = @"lastest_version";

