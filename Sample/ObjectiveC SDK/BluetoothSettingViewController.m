//
//  BluetoothSettingViewController.m
//  ObjectiveC SDK
//
//  Created by *** on 2017/**/**.
//  Copyright © 2017年 Star Micronics. All rights reserved.
//

#import "BluetoothSettingViewController.h"

#import "AppDelegate.h"

#import <StarIO/SMPort.h>

#import <StarIO_Extension/StarIoExt.h>
#import <StarIO_Extension/SMBluetoothManagerFactory.h>

typedef NS_ENUM(NSUInteger, AlertViewIndex) {
    AlertViewIndexPosModelSecurity = 0,
    AlertViewIndexPortableModelSecurity,
    AlertViewIndexFailToGetFirmwareInformation,
    AlertViewIndexNotSupportedFirmwareVersion,
    AlertViewIndexNotNumericalPinWarning,
    AlertViewIndexComplete,
};

typedef NS_ENUM(NSUInteger, TableCellIndex) {
    TableCellIndexDeviceName = 0,
    TableCellIndexiOSPortName,
    TableCellIndexPinCode,
};

@interface BluetoothSettingViewController ()

@property (nonatomic) SMBluetoothManager *bluetoothManager;

@property (nonatomic) BOOL changePinCode;

@property (nonatomic) BOOL isSMLSeries;

@property (nonatomic) NSMutableArray *cellArray;

@property (nonatomic) BOOL didAppear;

-(void)loadSettings;

@end

@implementation BluetoothSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self appendRefreshButton:@selector(loadSettings)];
    
    NSString           *portName = [AppDelegate getPortName];
    StarIoExtEmulation emulation = [AppDelegate getEmulation];
    
    self.bluetoothManager = [SMBluetoothManagerFactory getManager:portName emulation:emulation];
    
    _changePinCode = NO;
    
    _isSMLSeries = NO;
    
    _cellArray = [[NSMutableArray alloc] init];
    
    _didAppear = NO;
    
    _applyButton.enabled           = NO;
    _applyButton.backgroundColor   = [UIColor cyanColor];
    _applyButton.layer.borderColor = [UIColor blueColor].CGColor;
    _applyButton.layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_didAppear == NO) {
        // Check firmware version before loading bluetooth setting.
        NSDictionary *info = [self getFirmwareInformation];
        
        if (info == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to Open Port."
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            alertView.tag = AlertViewIndexFailToGetFirmwareInformation;
            [alertView show];
            
            return;
        }
        
        NSString *modelName       = [info objectForKey:@"ModelName"];
        NSString *firmwareVersion = [info objectForKey:@"FirmwareVersion"];
        
        // Bluetooth setting feature is supported from Ver3.0 or later (SM-S210i, SM-S220i, SM-T300i and SM-T400i).
        if ([modelName hasPrefix:@"SM-S21"] ||
            [modelName hasPrefix:@"SM-S22"] ||
            [modelName hasPrefix:@"SM-T30"] ||
            [modelName hasPrefix:@"SM-T40"]) {
            if (firmwareVersion.doubleValue < 3.0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail to get firmware information."
                                                                    message:[NSString stringWithFormat:@"%@ (%@) %@", @"This firmware version",
                                                                             firmwareVersion,
                                                                             @"of the device does not support bluetooth setting feature."]
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                alertView.tag = AlertViewIndexNotSupportedFirmwareVersion;
                [alertView show];
                
                return;
            }
        }
        
        self.isSMLSeries = [modelName hasPrefix:@"SM-L"];
        
        [self loadSettings];
        
        self.didAppear = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0 ||
        indexPath.row == 1 ||
        indexPath.row == 5) {
        static NSString *CellIdentifier = @"TextFieldTableViewCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TextFieldTableViewCell *customCell = (TextFieldTableViewCell *) cell;
        
        customCell.titleLabel.text = _cellArray[indexPath.row];
        
        customCell.delegate = self;
        
        switch (indexPath.row) {
            case 0 :
                if (self.bluetoothManager.deviceNameCapability == SMBluetoothSettingCapabilitySupport) {
                    customCell.textField.text = self.bluetoothManager.deviceName;
                    customCell.textField.enabled = YES;
                }
                else {
                    customCell.textField.text = @"N/A";
                    customCell.textField.enabled = NO;
                }
                
                customCell.tag = TableCellIndexDeviceName;
                break;
            case 1 :
                if (self.bluetoothManager.iOSPortNameCapability == SMBluetoothSettingCapabilitySupport) {
                    customCell.textField.text = self.bluetoothManager.iOSPortName;
                    customCell.textField.enabled = YES;
                }
                else {
                    customCell.textField.text = @"N/A";
                    customCell.textField.enabled = NO;
                }
                
                customCell.tag = TableCellIndexiOSPortName;
                break;
//          case 5 :
            default :
                if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilitySupport) {
                    if (customCell.textField.enabled && _changePinCode == NO) {
                        customCell.textField.text = @"";
                        
                        self.bluetoothManager.pinCode = nil;
                    }
                    else {
                        customCell.textField.text = self.bluetoothManager.pinCode;
                    }
                    
                    customCell.textField.enabled = _changePinCode;
                }
                else {
                    customCell.textField.text = @"N/A";
                    customCell.textField.enabled = NO;
                }
                
                customCell.textField.placeholder = @"Input New PIN Code";
                
                customCell.tag = TableCellIndexPinCode;
                break;
        }
    }
    else if (indexPath.row == 2 ||
             indexPath.row == 4) {
        static NSString *CellIdentifier = @"SwitchTableViewCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SwitchTableViewCell *customCell = (SwitchTableViewCell *) cell;
        
        customCell.titleLabel.text = _cellArray[indexPath.row];
        
        customCell.delegate = self;
        
        switch (indexPath.row) {
            case 2 :
                if (self.bluetoothManager.autoConnectCapability == SMBluetoothSettingCapabilitySupport) {
                    customCell.stateSwitch.enabled = YES;
                    
                    customCell.stateSwitch.on = self.bluetoothManager.autoConnect;
                    
                    customCell.detailLabel.text = @"";
                }
                else {
                    customCell.stateSwitch.enabled = NO;
                    
                    customCell.stateSwitch.on = NO;
                    
                    customCell.detailLabel.text = @"N/A";
                }
                break;
//          case 4 :
            default :
                if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilitySupport) {
                    customCell.stateSwitch.on = _changePinCode;
                    
                    customCell.stateSwitch.enabled = YES;
                    
                    customCell.detailLabel.text = @"";
                }
                else {
                    customCell.stateSwitch.on = NO;
                    
                    customCell.stateSwitch.enabled = NO;
                    
                    customCell.detailLabel.text = @"N/A";
                }
                break;
        }
    }
    else {  // indexPath.row == 3
        static NSString *CellIdentifier = @"UITableViewCellStyleValue1";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = _cellArray[indexPath.row];
        
        if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilitySupport) {
            if (self.bluetoothManager.security == SMBluetoothSecuritySSP) {
                cell.detailTextLabel.text = @"SSP";
            }
            else if (self.bluetoothManager.security == SMBluetoothSecurityPINcode) {
                cell.detailTextLabel.text = @"PIN Code";
            }
            else {  // Disable
                cell.detailTextLabel.text = @"Disable";
            }
            
            cell.detailTextLabel.textColor = [UIColor blueColor];
        }
        else {
            cell.detailTextLabel.text = @"N/A";
            
            cell.detailTextLabel.textColor = [UIColor darkTextColor];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Sample";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilitySupport) {
            int       tag;
            NSString *security1;
            NSString *security2;
            
            if (self.bluetoothManager.deviceType == SMDeviceTypeDesktopPrinter ||
                self.bluetoothManager.deviceType == SMDeviceTypeDKAirCash) {
                tag = AlertViewIndexPosModelSecurity;
                security1 = @"SSP";
                security2 = @"PIN Code";
            }
            else {
                tag = AlertViewIndexPortableModelSecurity;
                security1 = @"PIN Code";
                security2 = @"Disable";
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Select security type."
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:security1, security2, nil];
            alertView.tag = tag;
            [alertView show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)touchUpInsideApplyButton:(id)sender {
    [self confirmSettings];
}

// Called when text field value changed.
- (BOOL)shouldChangeCharactersIn:(int)tag textValue:(NSString *)textValue range:(NSRange)range replacementString:(NSString *)replacementString {
    NSString *newTextValue = [textValue stringByReplacingCharactersInRange:range withString:replacementString];
    
    BOOL shouldChange = NO;
    
    switch (tag) {
        case TableCellIndexDeviceName :
            if ([self validateNameChars:newTextValue] &&
                newTextValue.length <= 16) {
                self.bluetoothManager.deviceName = newTextValue;
                
                shouldChange = YES;
            }
            else {
                shouldChange = NO;
            }
            break;
        case TableCellIndexiOSPortName :
            if ([self validateNameChars:newTextValue] &&
                newTextValue.length <= 16) {
                self.bluetoothManager.iOSPortName = newTextValue;
                
                shouldChange = YES;
            }
            else {
                shouldChange = NO;
            }
            break;
        default :
//      case TableCellIndex.pinCode.rawValue :
            if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilityNoSupport) {
                shouldChange = YES;
                
                break;
            }
            
            if (_isSMLSeries) {
                if ([self validateSMLSeriesPinCodeChars:newTextValue] &&
                    newTextValue.length <= 4) {
                    self.bluetoothManager.pinCode = newTextValue;
                    
                    shouldChange = YES;
                }
                else {
                    shouldChange = NO;
                }
            }
            else {
                if ([self validatePinCodeChars:newTextValue] &&
                    newTextValue.length <= 16) {
                    self.bluetoothManager.pinCode = newTextValue;
                    
                    shouldChange = YES;
                }
                else {
                    shouldChange = NO;
                }
            }
            break;
    }
    
    self.applyButton.enabled = [self validateStringSettings];
    
    return shouldChange;
}

// Called when switch value changed.
- (void)tableView:(UITableView *)tableView valueChangedStateSwitch:(BOOL)on indexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 2 :
            self.bluetoothManager.autoConnect = on;
            break;
//      case 4 :
        default:
            self.changePinCode = on;
            break;
    }
    
    self.applyButton.enabled = [self validateStringSettings];
    
    [_tableView reloadData];
}

- (void)alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        switch (alertView.tag) {
            case AlertViewIndexPosModelSecurity :
                switch (buttonIndex - 1) {
                    case 0 :
                        self.bluetoothManager.security = SMBluetoothSecuritySSP;
                        break;
//                  case 1  :
                    default :
                        self.bluetoothManager.security = SMBluetoothSecurityPINcode;
                        break;
                }
                
                _applyButton.enabled = [self validateStringSettings];
                
                [self refreshTableView];
                
                break;
            case AlertViewIndexPortableModelSecurity :
                switch (buttonIndex - 1) {
                    case 0 :
                        self.bluetoothManager.security = SMBluetoothSecurityPINcode;
                        break;
//                  case 1  :
                    default :
                        self.bluetoothManager.security = SMBluetoothSecurityDisable;
                        break;
                }
                
                _applyButton.enabled = [self validateStringSettings];
                
                [self refreshTableView];
                
                break;
            case AlertViewIndexFailToGetFirmwareInformation :
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case AlertViewIndexNotSupportedFirmwareVersion :
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case AlertViewIndexNotNumericalPinWarning :
                if (buttonIndex == 1) {
                    [self applySettings];
                }
                break;
            case AlertViewIndexComplete :
                [self.navigationController popViewControllerAnimated:YES];
                break;
        }
    }
}

- (void)refreshTableView {
    [_cellArray removeAllObjects];
    
    [_cellArray addObject:@"Device Name"];
    [_cellArray addObject:@"iOS Port Name"];
    [_cellArray addObject:@"Auto Connect"];
    [_cellArray addObject:@"Security"];
    [_cellArray addObject:@"Change PIN Code"];
    [_cellArray addObject:@"New PIN Code"];
    
    [_tableView reloadData];
}

- (NSDictionary *)getFirmwareInformation {
    self.blind = YES;
    
    SMPort       *port = nil;
    NSDictionary *dict = nil;
    
    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    @try {
        port = [SMPort getPort:portName :portSettings :10000];
        
        if (port == nil) {
            return nil;
        }
        
        dict = [port getFirmwareInformation];
    }
    @catch (PortException *exception) {
    }
    @finally {
        [SMPort releasePort:port];
    }
    
    self.blind = NO;
    
    return dict;
}

- (void)loadSettings {
    self.blind = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    
    if ([self.bluetoothManager open] == NO) {
        [_cellArray removeAllObjects];
        
        [_tableView reloadData];
        
        _applyButton.enabled = NO;
        
        alertView.title = @"Fail to Open Port.";
        
        [alertView show];
        
        self.blind = NO;
        
        return;
    }
    
    if ([self.bluetoothManager loadSetting] == NO) {
        [_cellArray removeAllObjects];
        
        [_tableView reloadData];
        
        _applyButton.enabled = NO;
        
        alertView.title = @"Fail to load settings.";
        
        [alertView show];
        
        [self.bluetoothManager close];
        
        self.blind = NO;
        
        return;
    }
    
    [self.bluetoothManager close];
    
    self.blind = NO;
    
    _changePinCode = NO;
    
    _applyButton.enabled = [self validateStringSettings];
    
    [self refreshTableView];
}

- (void)confirmSettings {
    if ((self.bluetoothManager.deviceType == SMDeviceTypeDesktopPrinter) ||
        (self.bluetoothManager.deviceType == SMDeviceTypeDKAirCash)) {
        if (self.bluetoothManager.autoConnect == YES &&
            self.bluetoothManager.security    == SMBluetoothSecurityPINcode) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Auto Connection function is available only when the security setting is \"SSP\"."
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
            
            return;
        }
    }
    
    if (_changePinCode) {
        if (![self validateSMLSeriesPinCodeChars:self.bluetoothManager.pinCode]) {      // Unless PIN Code contains only numeric characters.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                                message:@"iPhone and iPod touch cannot use Alphabet PIN code, iPad only can use."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"OK", nil];
            
            alertView.tag = AlertViewIndexNotNumericalPinWarning;
            [alertView show];
            
            return;
        }
    }
    else {
        self.bluetoothManager.pinCode = nil;
    }
    
    [self applySettings];
}

- (void)applySettings {
    if ([self validateStringSettings] == NO) {
        return;
    }
    
    self.blind = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    
    if ([self.bluetoothManager open] == NO) {
        alertView.title = @"Fail to Open Port.";
        
        [alertView show];
        
        self.blind = NO;
        
        return;
    }
    
    if ([self.bluetoothManager apply] == NO) {
        alertView.title = @"Fail to apply settings.";
        
        [alertView show];
        
        [self.bluetoothManager close];
        
        self.blind = NO;
        
        return;
    }
    
    [self.bluetoothManager close];
    
    self.blind = NO;
    
    alertView.title    = @"Complete";
    alertView.message  = @"To apply settings, please turn the device power OFF and ON, and establish pairing again.";
    alertView.delegate = self;
    alertView.tag      = AlertViewIndexComplete;
    
    [alertView show];
}

- (BOOL)validateStringSettings {
    BOOL isValidDeviceName = YES;
    
    // Device name and iOS port name can use alphabetical(A-Z,a-z), numeric(0-9) and some symbol characters(see SDK manual),
    // and its length must be from 1 to 16.
    if (self.bluetoothManager.deviceNameCapability == SMBluetoothSettingCapabilitySupport) {
        isValidDeviceName = [self validateNameChars :self.bluetoothManager.deviceName] &&
        [self validateNameLength:self.bluetoothManager.deviceName];
    }
    
    BOOL isValidiOSPortName = YES;
    
    if (self.bluetoothManager.iOSPortNameCapability == SMBluetoothSettingCapabilitySupport) {
        isValidiOSPortName = [self validateNameChars :self.bluetoothManager.iOSPortName] &&
        [self validateNameLength:self.bluetoothManager.iOSPortName];
    }
    
    BOOL isValidPinCode = YES;
    
    // PIN code for SM-L series must be four numeric(0-9) characteres.
    // Other models can use alphabetical(A-Z,a-z) and numeric(0-9) PIN code, and its length must be from 4 to 16.
    if (self.bluetoothManager.pinCodeCapability == SMBluetoothSettingCapabilitySupport &&
        _changePinCode) {
        
        if (_isSMLSeries == YES) {
            isValidPinCode = [self validateSMLSeriesPinCodeChars :self.bluetoothManager.pinCode] &&
            [self validateSMLSeriesPinCodeLength:self.bluetoothManager.pinCode];
        }
        else {
            isValidPinCode = [self validatePinCodeChars: self.bluetoothManager.pinCode] &&
            [self validatePinCodeLength:self.bluetoothManager.pinCode];
        }
    }
    
    return isValidDeviceName && isValidiOSPortName && isValidPinCode;
}

- (BOOL)validateNameChars:(NSString *)name {
    if (name == nil) {
        return NO;
    }
    
    NSRange range = [name rangeOfString:@"^[A-Za-z0-9;:!?#$%&,.@_\\-= \\\\/\\*\\+~\\^\\[\\{\\(\\]\\}\\)\\|]*$"
                                options:NSRegularExpressionSearch];
    
    return range.location != NSNotFound;
}

- (BOOL)validatePinCodeChars:(NSString *)pinCode {
    if (pinCode == nil) {
        return NO;
    }
    
    NSRange range = [pinCode rangeOfString:@"^[A-Za-z0-9]*$"
                                   options:NSRegularExpressionSearch];
    
    return range.location != NSNotFound;
}

- (BOOL)validateSMLSeriesPinCodeChars:(NSString *)pinCode {
    if (pinCode == nil) {
        return NO;
    }
    
    NSRange range = [pinCode rangeOfString:@"^[0-9]*$"
                                   options:NSRegularExpressionSearch];
    
    return range.location != NSNotFound;
}

- (BOOL)validateNameLength:(NSString *)name {
    if (name == nil) {
        return NO;
    }
    
    return [name length] >= 1 && [name length] <= 16;
}

- (BOOL)validatePinCodeLength:(NSString *)pinCode {
    if (pinCode == nil) {
        return NO;
    }
    
    return [pinCode length] >= 4 && [pinCode length] <= 16;
}

- (BOOL)validateSMLSeriesPinCodeLength:(NSString *) pinCode {
    if (pinCode == nil) {
        return NO;
    }
    
    return [pinCode length] == 4;
}

@end