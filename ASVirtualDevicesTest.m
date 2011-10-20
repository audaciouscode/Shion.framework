//
//  ASVirtualDevicesTest.m
//  Shion Framework
//
//  Created by Chris Karr on 12/9/08.
//  Copyright 2008 Audacious Software. 
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//

#import "ASVirtualDevicesTest.h"

#import "ASVirtualDeviceController.h"
#import "ASVirtualAddress.h"
#import "ASContinuousDevice.h"
#import "ASCommands.h"
#import "ASInsteonAddress.h"
#import "ASDevice.h"
#import "ASDeviceController.h"
#import "ASPowerLincUSBController.h"
#import "ASX10Address.h"

#import "ASThermostatDevice.h"

@implementation ASVirtualDevicesTest

- (void) testPowerLincController
{
	/* ASDevice * overhead = [[ASContinuousDevice alloc] init];
	ASInsteonAddress * overAddress = [[ASInsteonAddress alloc] init];
	[overAddress setAddress:[ASInsteonAddress addressForString:@"0e76f2"]];
	[overhead setAddress:overAddress];
	[overAddress release];

	ASDevice * lamp = [[ASToggleDevice alloc] init];
	ASInsteonAddress * lampAddress = [[ASInsteonAddress alloc] init];
	[lampAddress setAddress:[ASInsteonAddress addressForString:@"0aa59c"]];
	[lamp setAddress:lampAddress];
	[lampAddress release];

	ASDevice * lava = [[ASToggleDevice alloc] init];
	ASX10Address * lavaAddress = [[ASX10Address alloc] init];
	[lavaAddress setAddress:[ASX10Address xTenAddressForString:@"A1"]];
	[lava setAddress:lavaAddress];
	[lavaAddress release];
	
	ASDeviceController * deviceController = [ASDeviceController controllerForDevice:overhead];
	STAssertNotNil (deviceController, @"Unable to locate controller for device '%@'.", overhead);
	STAssertTrue ([deviceController isMemberOfClass:[ASPowerLincUSBController class]], @"Controller is not a USB PowerLinc.");

	ASCommand * command = [deviceController commandForDevice:overhead kind:AS_DEACTIVATE];
	[deviceController queueCommand:command];

	command = [deviceController commandForDevice:lamp kind:AS_ACTIVATE];
	[deviceController queueCommand:command];

	command = [deviceController commandForDevice:lava kind:AS_DEACTIVATE];
	[deviceController queueCommand:command];

	command = [deviceController commandForDevice:overhead kind:AS_ACTIVATE];
	[command setValue:[NSDate dateWithTimeIntervalSinceNow:5] forKey:COMMAND_DATE];
	[deviceController queueCommand:command];
	
	command = [deviceController commandForDevice:lamp kind:AS_DEACTIVATE];
	[command setValue:[NSDate dateWithTimeIntervalSinceNow:7] forKey:COMMAND_DATE];
	[deviceController queueCommand:command];
	
	command = [deviceController commandForDevice:lava kind:AS_ACTIVATE];
	[command setValue:[NSDate dateWithTimeIntervalSinceNow:9] forKey:COMMAND_DATE];
	[deviceController queueCommand:command]; */
	
	ASDevice * thermostat = [[ASThermostatDevice alloc] init];
	ASInsteonAddress * thermostatAddress = [[ASInsteonAddress alloc] init];
	[thermostatAddress setAddress:[ASInsteonAddress addressForString:@"0e6906"]];
	[thermostat setAddress:thermostatAddress];
	[thermostatAddress release];

	ASDeviceController * deviceController = [ASDeviceController controllerForDevice:thermostat];
	STAssertNotNil (deviceController, @"Unable to locate controller for device '%@'.", thermostat);
	STAssertTrue ([deviceController isMemberOfClass:[ASPowerLincUSBController class]], @"Controller is not a USB PowerLinc.");
	
	ASCommand * command = [deviceController commandForDevice:thermostat kind:AS_GET_HVAC_TEMP];
	STAssertNotNil (command, @"command is nil for %@", thermostat);
	[deviceController queueCommand:command];

	/* ASCommand * getMode = [deviceController commandForDevice:thermostat kind:AS_GET_HVAC_STATE];
	STAssertNotNil (getMode, @"command is nil for %@", thermostat);
	STAssertTrue([getMode isKindOfClass:[ASGetThermostatState class]], @"command is not thermostat get state");
	[deviceController queueCommand:getMode];

	ASCommand * setMode = [deviceController commandForDevice:thermostat kind:AS_SET_HVAC_MODE value:[NSNumber numberWithUnsignedChar:MODE_FAN_OFF]];
	STAssertNotNil (setMode, @"command is nil for %@", thermostat);
	STAssertTrue([setMode isKindOfClass:[ASSetThermostatModeCommand class]], @"command is not thermostat set mode");
	[deviceController queueCommand:setMode];
	
	ASCommand * startBcast = [deviceController commandForDevice:thermostat kind:AS_ACTIVATE_HVAC_BROADCAST];
	STAssertNotNil (startBcast, @"command is nil for %@", thermostat);
	[deviceController queueCommand:startBcast]; */
	
	ASCommand * setHeat = [deviceController commandForDevice:thermostat kind:AS_SET_HEAT_POINT value:[NSNumber numberWithInt:73]];
	[deviceController queueCommand:setHeat];

	ASCommand * setCool = [deviceController commandForDevice:thermostat kind:AS_SET_COOL_POINT value:[NSNumber numberWithInt:87]];
	[setCool setValue:[NSDate dateWithTimeIntervalSinceNow:5] forKey:COMMAND_DATE];
	[deviceController queueCommand:setCool];

	NSRunLoop * loop = [NSRunLoop currentRunLoop];
	[loop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

/* - (void) testControllerManager
{
	STAssertNotNil(nil, @"foo");

	ASDevice * device = [[ASDevice alloc] init];
	STAssertNotNil(device, @"Virtual device is nil.");
	
	ASAddress * address = [[ASVirtualAddress alloc] init];
	[device setAddress:address];
	[address release];
	STAssertNotNil([device getAddress], @"Unable to retrieve address from device '%@'.", device);
	STAssertTrue ([[device getAddress] isMemberOfClass:[ASVirtualAddress class]], @"Address is the wrong kind.");
	
	ASDeviceController * deviceController = [ASVirtualDeviceController controllerForDevice:device];
	STAssertNotNil(deviceController, @"Unable to locate controller for device '%@'.", device);
	
	NSArray * devices = [deviceController devices];
	STAssertTrue((0 == [devices count]), @"Non-empty virtual device array.");
	
	[deviceController refresh];
	
	devices = [deviceController devices];
	STAssertTrue((3 == [devices count]), @"Virtual device array does not contain 3 items.");
	
	ASDevice * vanilla = [devices objectAtIndex:0];
	STAssertTrue([vanilla isMemberOfClass:[ASDevice class]], @"Device 0 is not a plain device.");
	
	ASToggleDevice * toggle = [devices objectAtIndex:1];
	STAssertTrue([toggle isMemberOfClass:[ASToggleDevice class]], @"Device 1 is not a toggle device.");

	ASContinuousDevice * continous = [devices objectAtIndex:2];
	STAssertTrue([continous isMemberOfClass:[ASContinuousDevice class]], @"Device 2 is not a toggle device.");

	
	ASCommand * command = [deviceController commandForDevice:vanilla kind:AS_STATUS];
	STAssertTrue([command isMemberOfClass:[ASStatusCommand class]], @"Command is not a status command.");

	command = [deviceController commandForDevice:vanilla kind:AS_ACTIVATE];
	STAssertNil(command, @"Command should be nil.");

	
	command = [deviceController commandForDevice:toggle kind:AS_STATUS];
	STAssertTrue([command isMemberOfClass:[ASStatusCommand class]], @"Command is not a status command.");
	
	command = [deviceController commandForDevice:toggle kind:AS_ACTIVATE];
	STAssertTrue([command isMemberOfClass:[ASActivateCommand class]], @"Command is not an activate command.");
	
	command = [deviceController commandForDevice:toggle kind:AS_DEACTIVATE];
	STAssertTrue([command isMemberOfClass:[ASDeactivateCommand class]], @"Command is not a deactivate command.");

	command = [deviceController commandForDevice:vanilla kind:AS_SET_LEVEL];
	STAssertNil(command, @"Command should be nil.");


	command = [deviceController commandForDevice:continous kind:AS_STATUS];
	STAssertTrue([command isMemberOfClass:[ASStatusCommand class]], @"Command is not a status command.");
	
	command = [deviceController commandForDevice:continous kind:AS_ACTIVATE];
	STAssertTrue([command isMemberOfClass:[ASActivateCommand class]], @"Command is not an activate command.");
	
	command = [deviceController commandForDevice:continous kind:AS_DEACTIVATE];
	STAssertTrue([command isMemberOfClass:[ASDeactivateCommand class]], @"Command is not a deactivate command.");

	command = [deviceController commandForDevice:continous kind:AS_INCREASE];
	STAssertTrue([command isMemberOfClass:[ASIncreaseCommand class]], @"Command is not an increase command.");
	
	command = [deviceController commandForDevice:continous kind:AS_DECREASE];
	STAssertTrue([command isMemberOfClass:[ASDecreaseCommand class]], @"Command is not a decrease command.");

	command = [deviceController commandForDevice:continous kind:AS_SET_LEVEL];
	STAssertTrue([command isMemberOfClass:[ASSetLevelCommand class]], @"Command is not a set level command.");

	STAssertNil([vanilla valueForKey:STATUS], @"Vanilla's status is not nil.");
	STAssertNil([toggle valueForKey:STATUS], @"Toggle's status is not nil.");
	STAssertNil([continous valueForKey:STATUS], @"Continous's status is not nil.");

	command = [deviceController commandForDevice:vanilla kind:AS_STATUS];
	[deviceController queueCommand:command];
	STAssertTrue([[deviceController queuedCommands] count] == 1, @"Only 1 command should be in queue.");
	[deviceController executeNextCommand];
	STAssertTrue([[deviceController queuedCommands] count] == 0, @"No commands should be in queue.");
	
	STAssertEqualObjects([vanilla valueForKey:STATUS], DEVICE_AVAILABLE, @"Vanilla's status should be visible.");
	
	command = [deviceController commandForDevice:toggle kind:AS_STATUS];
	[deviceController queueCommand:command];
	command = [deviceController commandForDevice:continous kind:AS_STATUS];
	[deviceController queueCommand:command];
	
	[deviceController executeNextCommand];
	STAssertEqualObjects([toggle valueForKey:STATUS], DEVICE_AVAILABLE, @"Toggle's status should be visible.");
	[deviceController executeNextCommand];
	STAssertFalse([((ASToggleDevice *) toggle) isActive], @"Toggle is not inactive.");

	[deviceController executeNextCommand];
	STAssertEqualObjects([continous valueForKey:STATUS], DEVICE_AVAILABLE, @"Continous's status should be visible.");
	[deviceController executeNextCommand];
	STAssertFalse([((ASToggleDevice *) continous) isActive], @"Continous is not inactive.");

	command = [deviceController commandForDevice:toggle kind:AS_ACTIVATE];
	[deviceController queueCommand:command];
	[deviceController executeNextCommand];
	STAssertTrue([((ASToggleDevice *) toggle) isActive], @"Toggle is not active.");

	command = [deviceController commandForDevice:continous kind:AS_ACTIVATE];
	[deviceController queueCommand:command];
	[deviceController executeNextCommand];
	STAssertTrue([((ASToggleDevice *) continous) isActive], @"Continous is not active.");

	command = [deviceController commandForDevice:toggle kind:AS_SET_LEVEL];
	STAssertNil(command, @"Set level command should be nil for toggle.");
	
	ASSetLevelCommand * setCommand = (ASSetLevelCommand *) [deviceController commandForDevice:continous kind:AS_SET_LEVEL];
	STAssertNotNil(setCommand, @"Set level command should not be nil for continous.");
	[setCommand setLevel:[NSNumber numberWithFloat:0.5]];
	STAssertEqualObjects([setCommand level], [NSNumber numberWithFloat:0.5], @"levels should both be 0.5");
	 
	[deviceController queueCommand:setCommand];
	[deviceController executeNextCommand];
	STAssertEqualObjects([continous level], [NSNumber numberWithFloat:0.5], @"continous level should be 0.5");
	
	command = [deviceController commandForDevice:continous kind:AS_INCREASE];
	[deviceController queueCommand:command];
	[deviceController executeNextCommand];
	STAssertEqualObjects([continous level], [NSNumber numberWithFloat:0.6], @"continous level should be 0.6");

	command = [deviceController commandForDevice:continous kind:AS_DECREASE];
	[deviceController queueCommand:command];
	[deviceController executeNextCommand];
	STAssertEqualObjects([continous level], [NSNumber numberWithFloat:0.5], @"continous level should be 0.5");
	
	STAssertTrue([[deviceController queuedCommands] count] == 0, @"Command queue should be empty.");
} */

@end
