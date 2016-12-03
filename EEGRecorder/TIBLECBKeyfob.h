//
//  TIBLECBKeyfob.h

//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "TIBLECBKeyfobDefines.h"
#import "globalVar.h"
#import "CKoSFTP.h"



@protocol TIBLECBKeyfobDelegate 
@optional
-(void) keyfobReady;
@required
-(void) accelerometerValuesUpdated:(float)x;
-(void) updateDropboxFile:(UInt8)original_data;

//-(void) textValuesUpdated:(NSString*)sData;
//-(void) keyValuesUpdated:(char)sw;
//-(void) TXPwrLevelUpdated:(char)TXPwr;
@end
// global variable == bad
 extern UInt8 packet_counter; //added
 extern BOOL wasDisconnected;

@interface TIBLECBKeyfob : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
}


//@property (nonatomic)   float batteryLevel;
//@property (nonatomic)   BOOL key1;
//@property (nonatomic)   BOOL key2;
@property (nonatomic)   char x;
//@property (nonatomic)   char y;
//@property (nonatomic)   char z;
//@property (nonatomic)   char TXPwrLevel;


@property (nonatomic,assign) id <TIBLECBKeyfobDelegate> delegate;
@property (strong, nonatomic)  NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *CM; 
@property (strong, nonatomic) CBPeripheral *activePeripheral;
//@property (strong, nonatomic) CBPeripheral *activePeripheral_copy;
@property (strong, nonatomic) UIButton *TIBLEConnectBtn;
//@property (copy,nonatomic) NSString *targetPeripheral;
//@property (strong, nonatomic) BOOL wasDisconnected;


//-(void) initConnectButtonPointer:(UIButton *)b;
//-(void) soundBuzzer:(Byte)buzVal p:(CBPeripheral *)p;
//-(void) readBattery:(CBPeripheral *)p;
-(void) enableAccelerometer:(CBPeripheral *)p;
-(void) disableAccelerometer:(CBPeripheral *)p;
//-(void) enableButtons:(CBPeripheral *)p;
//-(void) disableButtons:(CBPeripheral *)p;
//-(void) enableTXPower:(CBPeripheral *)p;
//-(void) disableTXPower:(CBPeripheral *)p;


-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p data:(NSData *)data;
-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p;
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID  p:(CBPeripheral *)p on:(BOOL)on;


-(UInt16) swap:(UInt16) s;
-(int) controlSetup:(int) s;
-(int) findBLEPeripherals:(int) timeout;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(void) connectPeripheral:(CBPeripheral *)peripheral;
//-(void) reconnectPeripheral:(CBPeripheral *)peripheral;
// prob going to call findBLEPeripherals

-(void) getAllServicesFromKeyfob:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(const char *) UUIDToString:(CFUUIDRef) UUID;
-(const char *) CBUUIDToString:(CBUUID *) UUID;
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt16) CBUUIDToInt:(CBUUID *) UUID;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;
-(NSString*)hexToBinary:(NSString*)hexString;




// will be invoked once disconnected
-(void)centralManager:(CBCentralManager *)central
didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(NSError *)error;

// will be invoked to reconnect
// first retrieve then call didretrieveconnected periphrals
- (void)retrieveConnectedPeripherals;
// call after disconnecting
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals;

@end
