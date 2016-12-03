//
//  TIBLECBKeyfob.m
//  TI-BLE-Demo
//  Copyright (c) 2011 ST alliance AS. All rights reserved.
//

#import "TIBLECBKeyfob.h"
//#import "CKoSFTP.h"
//#include <streamio.h>


@implementation TIBLECBKeyfob

@synthesize delegate;
@synthesize CM;
@synthesize peripherals;
@synthesize activePeripheral;
//@synthesize activePeripheral_copy;
@synthesize x;
@synthesize TIBLEConnectBtn;
//@synthesize targetPeripheral;
//@synthesize wasDisconnected;


//wasDisconnected = false;


/*!
 *  @method initConnectButtonPointer
 *
 *  @param b Pointer to the button
 *  @discussion Used to change the text of the button label during the connection cycle.
 */
//-(void) initConnectButtonPointer:(UIButton *)b {
//    TIBLEConnectBtn = b;
//}

/*!
 *  @method enableAccelerometer:
 *
 *  @param p CBPeripheral to write to
 *  @discussion Enables the accelerometer and enables notifications on X,Y and Z axis
 * *******************************************************************************************************************************/

-(void) enableAccelerometer:(CBPeripheral *)p {
    char data = 0x01;
    NSData *d = [[NSData alloc] initWithBytes:&data length:1];
    [self writeValue:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_ENABLER_UUID p:p data:d];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_X_UUID p:p on:YES];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Y_UUID p:p on:YES];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Z_UUID p:p on:YES];
    printf("Enabling accelerometer\r\n");
}

/*!
 *  @method disableAccelerometer:
 *
 *  @param p CBPeripheral to write to
 *  @discussion Disables the accelerometer and disables notifications on X,Y and Z axis
 * *******************************************************************************************************************************/

-(void) disableAccelerometer:(CBPeripheral *)p {
    char data = 0x00;
    NSData *d = [[NSData alloc] initWithBytes:&data length:1];
    [self writeValue:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_ENABLER_UUID p:p data:d];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_X_UUID p:p on:NO];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Y_UUID p:p on:NO];
    [self notification:TI_KEYFOB_ACCEL_SERVICE_UUID characteristicUUID:TI_KEYFOB_ACCEL_Z_UUID p:p on:NO];
    printf("Disabling accelerometer\r\n");
}



/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, value is written. If not nothing is done.
 * *******************************************************************************************************************************/

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic 
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 * *******************************************************************************************************************************/

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }  
    [p readValueForCharacteristic:characteristic];
    NSLog(@"FOUND CHARACTERISTIC ... %@",p);
    
}


/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers 
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service. 
 *  If this is found, the notfication is set.
 * *******************************************************************************************************************************/

-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}


/*!
 *  @method swap:
 *
 *  @param s Uint16 value to byteswap
 *  @discussion swap byteswaps a UInt16
 *  @return Byteswapped UInt16
 * *******************************************************************************************************************************/

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

/*!
 *  @method controlSetup:
 *
 *  @param s Not used
 *  @return Allways 0 (Success)
 *  @discussion controlSetup enables CoreBluetooths Central Manager and sets delegate to TIBLECBKeyfob class
 * *******************************************************************************************************************************/
- (int) controlSetup: (int) s{
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return 0;
}

/*
 *  @method findBLEPeripherals:
 *
 *  @param timeout timeout in seconds to search for BLE peripherals
 *  @return 0 (Success), -1 (Fault)
 *  @discussion findBLEPeripherals searches for BLE peripherals and sets a timeout when scanning is stopped
 * *******************************************************************************************************************************/

- (int) findBLEPeripherals:(int) timeout {
    
    if (self->CM.state  != CBCentralManagerStatePoweredOn) {
        printf("CoreBluetooth not correctly initialized !\r\n");
        printf("State = %d (%s)\r\n", self-> CM.state,[self centralManagerStateToString:self.CM.state]);
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Alert !"
                              message:@"CoreBluetooth not correctly initialized!"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        
        [alert show];
        return -1;
    }
    
    [self.CM scanForPeripheralsWithServices:nil options:0]; // Start scanning
    [TIBLEConnectBtn setTitle:@"Scanning.." forState:UIControlStateNormal];
    return 0; // Started scanning OK !
}


/*
 *  @method connectPeripheral:
 *
 *  @param p Peripheral to connect to
 *
 *  @discussion connectPeripheral connects to a given peripheral and sets the activePeripheral property of TIBLECBKeyfob.
 * *******************************************************************************************************************************/

- (void) connectPeripheral:(CBPeripheral *)peripheral {
    printf("Connecting to peripheral with UUID : %s\r\n",[self UUIDToString:(__bridge CFUUIDRef)(peripheral.identifier)]);
    
    //knownPeripherals = [CM retrievePeripheralsWithIdentifiers:savedIdentifiers];
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
//    activePeripheral_copy = peripheral;
//    activePeripheral_copy.delegate = self;
    [CM connectPeripheral:activePeripheral options:nil];
    [TIBLEConnectBtn setTitle:@"Connecting.." forState:UIControlStateNormal];
}

/*
 *  @method centralManagerStateToString:
 *
 *  @param state State to print info of
 *
 *  @discussion centralManagerStateToString prints information text about a given CBCentralManager state
 * *******************************************************************************************************************************/

- (const char *) centralManagerStateToString: (int)state{
    switch(state) {
        case CBCentralManagerStateUnknown: 
            return "State unknown (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateResetting:
            return "State resetting (CBCentralManagerStateUnknown)";
        case CBCentralManagerStateUnsupported:
            return "State BLE unsupported (CBCentralManagerStateResetting)";
        case CBCentralManagerStateUnauthorized:
            return "State unauthorized (CBCentralManagerStateUnauthorized)";
        case CBCentralManagerStatePoweredOff:
            return "State BLE powered off (CBCentralManagerStatePoweredOff)";
        case CBCentralManagerStatePoweredOn:
            return "State powered up and ready (CBCentralManagerStatePoweredOn)";
        default:
            return "State unknown";
    }
    return "Unknown state";
}

/*
 *  @method scanTimer:
 *
 *  @param timer Backpointer to timer
 *  @discussion scanTimer is called when findBLEPeripherals has timed out, it stops the CentralManager from scanning further and prints out information about known peripherals
 * *******************************************************************************************************************************/

- (void) scanTimer:(NSTimer *)timer {
    [self.CM stopScan];
    printf("Stopped Scanning\r\n");
    printf("Known peripherals : %d\r\n",[self->peripherals count]);
    [self printKnownPeripherals];	
}

/*
 *  @method printKnownPeripherals:
 *
 *  @discussion printKnownPeripherals prints all curenntly known peripherals stored in the peripherals array of TIBLECBKeyfob class
 * *******************************************************************************************************************************/

- (void) printKnownPeripherals {
    int i;
    printf("List of currently known peripherals : \r\n");
    for (i=0; i < self->peripherals.count; i++)
    {
        CBPeripheral *p = [self->peripherals objectAtIndex:i];
        CFStringRef s = CFUUIDCreateString(NULL, p.UUID);
        NSString  *s2 = [p.identifier UUIDString];

        printf("%d  |  %s\r\n",i,CFStringGetCStringPtr(s, 0));
        
        [self printPeripheralInfo:p];
    }
    
}

/*
 *  @method printPeripheralInfo:
 *  @param peripheral Peripheral to print info of 
 *
 *  @discussion printPeripheralInfo prints detailed info about peripheral
 * *******************************************************************************************************************************/

- (void) printPeripheralInfo:(CBPeripheral*)peripheral {
    CFStringRef s = CFUUIDCreateString(NULL, peripheral.UUID);
    printf("------------------------------------\r\n");
    printf("Peripheral Info :\r\n");
    printf("UUID : %s\r\n",CFStringGetCStringPtr(s, 0));
    printf("RSSI : %d\r\n",[peripheral.RSSI intValue]);
    printf("Name : %s\r\n",[peripheral.name UTF8String]);
    printf("isConnected : %d\r\n",peripheral.isConnected);
    printf("Description : %s\r\n",[peripheral.description UTF8String]);
    printf("Identifier : %s\r\n",[[peripheral.identifier UUIDString] UTF8String]);
    printf("State : %d\r\n",peripheral.state);
    printf("-------------------------------------\r\n");
    
    

}

/*
 *  @method UUIDSAreEqual:
 *
 *  @param u1 CFUUIDRef 1 to compare
 *  @param u2 CFUUIDRef 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *
 *  @discussion compares two CFUUIDRef's
 * *******************************************************************************************************************************/

- (int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2 {
    CFUUIDBytes b1 = CFUUIDGetUUIDBytes(u1);
    CFUUIDBytes b2 = CFUUIDGetUUIDBytes(u2);
    if (memcmp(&b1, &b2, 16) == 0) {
        return 1;
    }
    else return 0;
}


/*
 *  @method getAllServicesFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *  @discussion getAllServicesFromKeyfob starts a service discovery on a peripheral pointed to by p.
 *  When services are found the didDiscoverServices method is called
 * *******************************************************************************************************************************/

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p{
    [TIBLEConnectBtn setTitle:@"Discovering services.." forState:UIControlStateNormal];
    [p discoverServices:nil]; // Discover all services without filter
}

/*
 *  @method getAllCharacteristicsFromKeyfob
 *
 *  @param p Peripheral to scan
 *
 *  @discussion getAllCharacteristicsFromKeyfob starts a characteristics discovery on a peripheral pointed to by p
 * *******************************************************************************************************************************/
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    [TIBLEConnectBtn setTitle:@"Discovering characteristics.." forState:UIControlStateNormal];
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}


/*
 *  @method CBUUIDToString
 *
 *  @param UUID UUID to convert to string
 *  @returns Pointer to a character buffer containing UUID in string representation
 *  @discussion CBUUIDToString converts the data of a CBUUID class to a character pointer for easy printout using printf()
 * *******************************************************************************************************************************/

-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


/*
 *  @method UUIDToString
 *
 *  @param UUID UUID to convert to string
 *  @returns Pointer to a character buffer containing UUID in string representation
 *  @discussion UUIDToString converts the data of a CFUUIDRef class to a character pointer for easy printout using printf()
 * *******************************************************************************************************************************/

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);		
    
}

/*
 *  @method compareCBUUID
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *  @discussion compareCBUUID compares two CBUUID's to each other and returns 1 if they are equal and 0 if they are not
 * *******************************************************************************************************************************/

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}

/*
 *  @method compareCBUUIDToInt
 *
 *  @param UUID1 UUID 1 to compare
 *  @param UUID2 UInt16 UUID 2 to compare
 *
 *  @returns 1 (equal) 0 (not equal)
 *  @discussion compareCBUUIDToInt compares a CBUUID to a UInt16 representation of a UUID and returns 1 if they are equal and 0 if they are not
 * *******************************************************************************************************************************/

-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}

/*
 *  @method CBUUIDToInt
 *
 *  @param UUID1 UUID 1 to convert
 *  @returns UInt16 representation of the CBUUID
 *  @discussion CBUUIDToInt converts a CBUUID to a Uint16 representation of the UUID
 * *******************************************************************************************************************************/

-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

/*
 *  @method IntToCBUUID
 *
 *  @param UInt16 representation of a UUID
 *  @return The converted CBUUID
 *  @discussion IntToCBUUID converts a UInt16 UUID to a CBUUID
 * *******************************************************************************************************************************/

-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}


/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a service with a specific UUID
 * *******************************************************************************************************************************/

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service 
 *  to find a characteristic with a specific UUID
 * *******************************************************************************************************************************/

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

//----------------------------------------------------------------------------------------------------
//
//
//
//
//CBCentralManagerDelegate protocol methods beneeth here
// Documented in CoreBluetooth documentation
//
//
//
//
//----------------------------------------------------------------------------------------------------



- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    printf("Status of CoreBluetooth central manager changed %d (%s)\r\n",central.state,[self centralManagerStateToString:central.state]);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
/*    if (!self.peripherals) self.peripherals = [[NSMutableArray alloc] initWithObjects:peripheral,nil];
    else {
        for(int i = 0; i < self.peripherals.count; i++) {
            CBPeripheral *p = [self.peripherals objectAtIndex:i];
            if ([self UUIDSAreEqual:p.UUID u2:peripheral.UUID]) {
                [self.peripherals replaceObjectAtIndex:i withObject:peripheral];
                printf("Duplicate UUID found updating ...\r\n");
                return;
            }
        }
        [self->peripherals addObject:peripheral];
        printf("New UUID, adding\r\n");
    }
 */
 /*  NSMutableArray *pper = [self mutableArrayValueForKey:@"EEG Recorder"];
    if(![self.peripherals containsObject:peripheral])
        [pper addObject:peripheral];
    
    // Retrieve already known devices
    [self.CM retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];*/
    
    
    

        NSLog(@"Discovered peripheral %@ (%@)",peripheral.name,peripheral.identifier.UUIDString);
        if (![self.peripherals containsObject:peripheral] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.peripherals addObject:peripheral];
                //[self.tableview insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.discoveredPeripherals.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
            });
        }
    
    
    //CBPeripheral *targetPeripheral=(CBPeripheral *)self.peripherals[indexPath.row];

    
    
    if ([peripheral.name rangeOfString:@"Keyfob"].location != NSNotFound) {
        [self connectPeripheral:peripheral];
        printf("Found a keyfob, connecting..\n");
        NSLog(@"Device name : %@",peripheral.name);
    } else {
        printf("Peripheral not a keyfob or callback was not because of a ScanResponse\n");
    }
    
    printf("didDiscoverPeripheral\r\n");
    
    [self printPeripheralInfo:peripheral]; // PRINT DEVICE DATA
    [self printKnownPeripherals];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    printf("Connection to peripheral with UUID : %s successfull\r\n",[self UUIDToString:peripheral.UUID]);
    self.activePeripheral = peripheral;
    [self.activePeripheral discoverServices:nil];
    [central stopScan];
}

//----------------------------------------------------------------------------------------------------
//
//
//
//
//
//CBPeripheralDelegate protocol methods beneeth here
//
//
//
//
//
//----------------------------------------------------------------------------------------------------


/*
 *  @method didDiscoverCharacteristicsForService
 *
 *  @param peripheral Pheripheral that got updated
 *  @param service Service that characteristics where found on
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverCharacteristicsForService is called when CoreBluetooth has discovered 
 *  characteristics on a service, on a peripheral after the discoverCharacteristics routine has been called on the service
 *
 * *******************************************************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        printf("Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
        for(int i=0; i < service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i]; 
            printf("Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
            CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
            if([self compareCBUUID:service.UUID UUID2:s.UUID]) {
                printf("Finished discovering characteristics");
                [[self delegate] keyfobReady];
            }
        }
    }
    else {
        printf("Characteristic discovery unsuccessfull !\r\n");
        /*
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Alert !"
                              message:@"Characteristic discovery unsuccessfull ! Try to Connect Again!"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        
        [alert show];
    */
         }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
}

/*
 *  @method didDiscoverServices
 *
 *  @param peripheral Pheripheral that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didDiscoverServices is called when CoreBluetooth has discovered services on a 
 *  peripheral after the discoverServices routine has been called on the peripheral
 *
 * *******************************************************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (!error) {
        printf("Services of peripheral with UUID : %s found\r\n",[self UUIDToString:peripheral.UUID]);
        [self getAllCharacteristicsFromKeyfob:peripheral];
    }
    else {
        printf("Service discovery was unsuccessfull !\r\n");
        
        // turn off this alert, if the device has disconnected it will pop up every 3 seconds or so and will need to be exited out of
        
        
        /*UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Alert !"
                              message:@"Service discovery was unsuccessfull ! Try to Connect Again!"
                              delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil];
        
        [alert show]; */
        
        
    }
}

/*
 *  @method didUpdateNotificationStateForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateNotificationStateForCharacteristic is called when CoreBluetooth has updated a 
 *  notification state for a characteristic
 *
 * *******************************************************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (!error) {
        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
    }
    else {
        printf("Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
        printf("Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
    
}

/*
 *  @method didUpdateValueForCharacteristic
 *
 *  @param peripheral Pheripheral that got updated
 *  @param characteristic Characteristic that got updated
 *  @error error Error message if something went wrong
 *
 *  @discussion didUpdateValueForCharacteristic is called when CoreBluetooth has updated a 
 *  characteristic for a peripheral. All reads and notifications come here to be processed.
 *
 * *******************************************************************************************************************************/


/**
  convert from hex to binary
 
 */

-(NSString*)hexToBinary:(NSString*)hexString {
    NSMutableString *retnString = [NSMutableString string];
    for(int i = 0; i < [hexString length]; i++) {
        char c = [[hexString lowercaseString] characterAtIndex:i];
        if ((c != '<') && (c != '>'))
        {
        switch(c) {
            case '0': [retnString appendString:@"0000"]; break;
            case '1': [retnString appendString:@"0001"]; break;
            case '2': [retnString appendString:@"0010"]; break;
            case '3': [retnString appendString:@"0011"]; break;
            case '4': [retnString appendString:@"0100"]; break;
            case '5': [retnString appendString:@"0101"]; break;
            case '6': [retnString appendString:@"0110"]; break;
            case '7': [retnString appendString:@"0111"]; break;
            case '8': [retnString appendString:@"1000"]; break;
            case '9': [retnString appendString:@"1001"]; break;
            case 'a': [retnString appendString:@"1010"]; break;
            case 'b': [retnString appendString:@"1011"]; break;
            case 'c': [retnString appendString:@"1100"]; break;
            case 'd': [retnString appendString:@"1101"]; break;
            case 'e': [retnString appendString:@"1110"]; break;
            case 'f': [retnString appendString:@"1111"]; break;
            default : break;
        }
        }
    }
    
    return retnString;
}

/*************************** EDITTED LUCAS **********************/

UInt16 xval_tmp = 0;
float xval_tmp_float = 0;

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    UInt16 characteristicUUID = [self CBUUIDToInt:characteristic.UUID];
    
    if (!error) {
        switch(characteristicUUID){
            case TI_KEYFOB_LEVEL_SERVICE_UUID:
//            {
//                char batlevel;
//                [characteristic.value getBytes:&batlevel length:TI_KEYFOB_LEVEL_SERVICE_READ_LEN];
//                self.batteryLevel = (float)batlevel;
                break;
//            }
            case TI_KEYFOB_KEYS_NOTIFICATION_UUID:
//            {
//                char keys;
//                [characteristic.value getBytes:&keys length:TI_KEYFOB_KEYS_NOTIFICATION_READ_LEN];
//                if (keys & 0x01) self.key1 = YES;
//                else self.key1 = NO;
//                if (keys & 0x02) self.key2 = YES;
//                else self.key2 = NO;
//                [[self delegate] keyValuesUpdated: keys];
                break;
//            }
            case TI_KEYFOB_ACCEL_X_UUID:
            {
                //extern UInt8 packet_counter;
                //UInt8 xval[20];
                int xval[20];
                // length:1 means there this is pulling one byte at a time or 8 bits
                
                // my assumption is that there is a problem here
                // there needs to be a conversion from hexidecimal to binary here
                // there is a 5 packet of these hex values one hex is 4 bytes, so 20 bytes total it just needs to be convereted properly first
                
                // <17191b1d 1f212325 27292b2d 2f313335 37393b3d>
               
                //[characteristic.value getBytes:&xval length:TI_KEYFOB_ACCEL_READ_LEN];
                
                
                //  printf(NSString(characteristic.value));
                
               // NSString *some = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                
                NSLog(@"This is the characteristic %@ and length %lu \n",characteristic.value, (unsigned long)characteristic.value.length);
                
                //NSString* newStr = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                //NSLog(@"The string version of the characteristic %@", newStr);
                
                NSString *val = @"";
                val = [val stringByAppendingFormat: @"%@",characteristic.value];
                
                NSLog(@"%@",val);
                
                NSString *temp = @"";
                //temp = [self hexToBinary:val];
                
                

                
                //NSString *s = @"Some string";
                const char *c = [val UTF8String];
                // I feel that there's an easy one-liner if I were to convert to NSData
                int number = [temp intValue];
                NSLog(@"%@ \n %s \n%c \n %c \n %d \n %lu ",temp,c,c[1],c[2],number,strlen(c));
                
                int counter_filler = 0;
                NSString *toFill = @"";
                int xval_counter = 0;
                // fill array
                unsigned binar;
                
                
                for (int i = 0; i < strlen(c);i++)
                {
                    if (c[i] != '<' && c[i] != '>' && c[i] != ' ')
                    {
                        
                
                    if (counter_filler == 2)
                    {
                        counter_filler = 0;
                        toFill = @"";
                        
                    }
                    // make it a string
                    toFill = [toFill stringByAppendingFormat: @"%c",c[i]];
                    if (counter_filler == 1)
                    {
                         //unsigned result = 0;
                         NSScanner *scanner = [NSScanner scannerWithString:toFill];
                        
                        //[scanner setScanLocation:1]; // bypass '#' character
                        [scanner scanHexInt:&binar];
                        
                        NSLog(@"%u",binar);
                        //binar = [toFill intValue];
                        // new = binar;
                        xval[xval_counter] = binar;
                        xval_counter++;
                    }
                    
                    // then make it an integer
                    counter_filler++;
                    }
                    
                }
                
                
                
                
                
             /*   for (int i = 0; i < 20; i++)
                {
                    NSMutableString *str = [NSMutableString stringWithCapacity:8];

                    for (int n = 0; n < 8; n++)
                    {
                        //str = [str stringByAppendingFormat: @"%hu",[temp characterAtIndex:i*8+n]];
                  //      NSString *temp_str = @"";
                        
            //            [str insertString: [c characterAtIndex:i*8*n] atIndex:n];
                    }
                    NSLog(@"%@",str);
                    NSData *someData = [str dataUsingEncoding:NSUTF8StringEncoding];
                    const void *bytes = [someData bytes];
                    //int length = [someData length];
                    
                    //Easy way
                    uint8_t *crypto_data = (uint8_t*)bytes;
                    xval[i] = *crypto_data;
                }*/
                
                
                
                //NSData* data = [temp dataUsingEncoding:NSUTF8StringEncoding];
                //[temp getBytes:&xval length:TI_KEYFOB_ACCEL_READ_LEN];
                
                //NSString *val;
                //val = hexToBinary(characteristic.value);
               /* NSLog(@"This is the characteristic %@",characteristic.handle);
                NSLog(@"This is the characteristic %@",characteristic.value);
                NSLog(@"This is the characteristic %@",characteristic.value);
                */
                
                
                
                //printf(TI_KEYFOB_ACCEL_X_UUID.value);
                // [self.activePeripheral getBytes:&xval length:TI_KEYFOB_ACCEL_READ_LEN];
                // printf(xval);
                // the binary value needs to get 12 bits not 8
                            
                if (packet_counter == 0)
                {
                    for (int i=0; i<18; i=i+3)
                    {
                        // xval[i] is the first 4 bits it seems 16 is the total permutations
                        // xval[i+1] next 4 bits, for some reason being divided by 16
                        //printf(xval[i]);
                        xval_tmp = xval[i]*16 + xval[i+1]/16;                   // xval_tmp is not a float, so it won't have decimal point
                        
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;    // Need to convert from ADC output to uV
                        //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                        
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];
                        // added
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        xval_tmp = (xval[i+1] - (xval[i+1]/16)*16)*256 + xval[i+2];
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;
                        //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                        
                        NSLog(@"%hu \t %f",xval_tmp,xval_tmp_float);
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];
                        
                        // added
                       // [[self delegate] updateDropboxFile:xval_tmp_float];
                        // this is where the data is actually sent through
                        // there will be 6 points of data
                        // i'm not sure why we're pushing in xval[] data here because it's essentially unintelligable unless converted to uV like above
                       
                        
                       
                        [[self delegate] updateDropboxFile:xval[i]];
                        [[self delegate] updateDropboxFile:xval[i+1]];
                        [[self delegate] updateDropboxFile:xval[i+2]];
                        
                         
                        
                       /***** added by Lucas *****/
                     //     [[self delegate] updateDropboxFile:xval_tmp_float];
                     //   [[self delegate] updateDropboxFile:xval_tmp_float];
                     //   [[self delegate] updateDropboxFile:xval_tmp_float];
                        
                    }
                    
                    int i = 18;                                                         // Need to get the rest of the data (when i = 18)
                    xval_tmp = xval[i]*16 + xval[i+1]/16;                               // xval_tmp is not a float, so it won't have decimal point
                    xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;                // Need to convert from ADC output to uV
                    //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                    [[self delegate] accelerometerValuesUpdated:xval_tmp_float];        // [bleData  appendFormat:@"%f", xval_tmp_float];
                    
                    //added
                    //[[self delegate] updateDropboxFile:xval_tmp_float];
                    xval_tmp = (xval[i+1] - (xval[i+1]/16)*16)*256;                     // xval[20] is not available yet + xval[i+2];
                    
                    
                    
                    [[self delegate] updateDropboxFile:xval[i]];
                    [[self delegate] updateDropboxFile:xval[i+1]];
                    //*///////////
                    
                    
                    /*** added by me **/
                    //[[self delegate] updateDropboxFile:xval_tmp_float];
                    //[[self delegate] updateDropboxFile:xval[i+1]];
                    //printf(xval);
                    packet_counter = 1;
                    
                }
                else if (packet_counter == 1)
                {
                    
                    xval_tmp = xval_tmp + xval[0];                                      // need to get the last 8 bits
                    xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;                // Need to convert from ADC output to uV
                    //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                    //printf(xval);
                    [[self delegate] updateDropboxFile:xval[0]];                        //[bleData  appendFormat:@"%f", xval_tmp_float];
                    //[[self delegate] updateDropboxFile:xval_tmp_float]; // added by lucas
                    [[self delegate] accelerometerValuesUpdated:xval_tmp_float];
                    
                    for (int i=1; i<19; i=i+3)
                    {
                        // printf(xval[i]);
                        xval_tmp = xval[i]*16 + xval[i+1]/16;                           // xval_tmp is not a float, so it won't have decimal points
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;            // Need to convert from ADC output to uV
                        
                        //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                        
                        
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];    //  [bleData  appendFormat:@"%f", xval_tmp_float];
                        
                        // added
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        xval_tmp = (xval[i+1] - (xval[i+1]/16)*16)*256 + xval[i+2];     // xval_tmp is not a float, so it won't have decimal points
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;            // Need to convert from ADC output to uV
                        //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                        
                        
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];    // [bleData  appendFormat:@"%f", xval_tmp_float];
                        
                        // added
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        
                        // i don't understand why xval is being sent to the server, it's not converted
                        
                        
                        
                        [[self delegate] updateDropboxFile:xval[i]];
                        [[self delegate] updateDropboxFile:xval[i+1]];
                        [[self delegate] updateDropboxFile:xval[i+2]];
                        
                        NSLog(@"%hu \t %f",xval_tmp,xval_tmp_float);
        
                        
                        
                        /**** added by lucas ****/
                        
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        
                        
                    }
                    
                    int i = 19;                                                         // Need to get the rest of the data (when i = 19)
                    xval_tmp = xval[i]*16;                                              // missing the rest
                    [[self delegate] updateDropboxFile:xval[i]];
                    //[[self delegate] updateDropboxFile:xval_tmp_float];   // might need to convert this to uV as well
                    //printf(xval);
                    packet_counter = 2;
                    
                }
                
                else if (packet_counter == 2)
                    
                {
                    xval_tmp = xval_tmp + xval[0]/16;                                   // xval_tmp is not a float, so it won't have decimal points
                    xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;                // Need to convert from ADC output to uV
                    
                    //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                    
                    
                    // commented
                    [[self delegate] updateDropboxFile:xval[0]];
                    
                    // added
                    //[[self delegate] updateDropboxFile:xval_tmp_float];
                    [[self delegate] accelerometerValuesUpdated:xval_tmp_float];        //[bleData  appendFormat:@"%f", xval_tmp_float];
                    
                    xval_tmp = (xval[0] - (xval[0]/16)*16)*256 + xval[1];               // xval_tmp is not a float, so it won't have decimal points
                    xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;                // Need to convert from ADC output to uV
                    //xval_tmp_float = (float)(xval_tmp - 2048)/1024;
                    
                    [[self delegate] updateDropboxFile:xval[1]];
                    
                    // added
                    //[[self delegate] updateDropboxFile:xval_tmp_float];
                    //[[self delegate] accelerometerValuesUpdated:xval_tmp_float];        //[bleData  appendFormat:@"%f", xval_tmp_float];
                    
                    
                    for (int i=2; i<20; i=i+3)
                    {
                        
                        xval_tmp = xval[i]*16 + xval[i+1]/16;                           // xval_tmp is not a float, so it won't have decimal points
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;            // Need to convert from ADC output to uV
                        //xval_tmp_float = (float)(xval_tmp - 2048)/1024;

                        
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];    //[bleData  appendFormat:@"%f", xval_tmp_float];
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                        xval_tmp = (xval[i+1] - (xval[i+1]/16)*16)*256 + xval[i+2];     // xval_tmp is not a float, so it won't have decimal points
                        xval_tmp_float = (float)(xval_tmp - 2048)*1000/1024;            // Need to convert from ADC output to uV
                       // xval_tmp_float = (float)(xval_tmp - 2048)/1024;

                        
                        [[self delegate] accelerometerValuesUpdated:xval_tmp_float];    //[bleData  appendFormat:@"%f", xval_tmp_float];
                       // [[self delegate] updateDropboxFile:xval_tmp_float];
                        
                        
                        [[self delegate] updateDropboxFile:xval[i]];
                        [[self delegate] updateDropboxFile:xval[i+1]];
                        [[self delegate] updateDropboxFile:xval[i+2]];
                        NSLog(@"%hu \t %f",xval_tmp,xval_tmp_float);

                        
                        //[[self delegate] updateDropboxFile:xval_tmp_float];
                    }
                    //printf(xval);
                    packet_counter = 0;
                    
                }
                
                
            
//                [[self delegate] textValuesUpdated:bleData];       // UPDATE LABELS DATA
                
                
                // self.x = xval;
               // [[self delegate] accelerometerValuesUpdated:self.x y:self.y z:self.z];
                break;
            }
            case TI_KEYFOB_ACCEL_Y_UUID:
            {
//                char yval; 
//                [characteristic.value getBytes:&yval length:TI_KEYFOB_ACCEL_READ_LEN];
//                self.y = yval;
//             //   [[self delegate] accelerometerValuesUpdated:self.x y:self.y z:self.z];
                break;
            }
            case TI_KEYFOB_ACCEL_Z_UUID:
            {
//                char zval; 
//                [characteristic.value getBytes:&zval length:TI_KEYFOB_ACCEL_READ_LEN];
//                self.z = zval;
            //    [[self delegate] accelerometerValuesUpdated:self.x y:self.y z:self.z];
                break;
            }
            case TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_UUID:
            {
//                char TXLevel;
//                [characteristic.value getBytes:&TXLevel length:TI_KEYFOB_PROXIMITY_TX_PWR_NOTIFICATION_READ_LEN];
//                self.TXPwrLevel = TXLevel;
//                [[self delegate] TXPwrLevelUpdated:TXLevel];
            }
        }
    }    
    else {
        printf("updateValueForCharacteristic failed !");
    }
}


// retrieve peripherals - save UUID then call it here

// didretrieveperipherals

// reconnect with connectPeripheral




-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [TIBLEConnectBtn setTitle:@"lost connection" forState:UIControlStateNormal];
    [central connectPeripheral:peripheral options:nil];
    wasDisconnected = true;
}


- (void)retrievePeripherals{
    
}
- (void) stopScan
{
    [self.CM stopScan];
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
        NSLog(@"Retrieved peripheral: %u - %@", [peripherals count], peripherals);
        [self stopScan];
        // If there are any known devices, automatically connect to it.
        if([peripherals count] >= 1) {
            self.activePeripheral = [peripherals objectAtIndex:0];
            [self.CM connectPeripheral:self.activePeripheral
                                    options:[NSDictionary dictionaryWithObject:
                                             [NSNumber numberWithBool:YES]
                                                                        forKey:
                                             CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        }
    }




- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    
}


@end
