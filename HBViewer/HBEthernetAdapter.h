#import "HBAdapterInterface.h"
#import "HBAdapterInterfaceDelegate.h"
#import "HBVersion.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

@interface HBEthernetAdapter : HBAdapterInterface <GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate>
@property (nonatomic, strong) NSString *mCurrentChannel;

@end
