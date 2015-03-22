#import "HBAdapterInterface.h"
#import "HBAdapterInterfaceDelegate.h"
#import "HBVersion.h"

@class GCDAsyncSocket;


@interface HBEthernetAdapter : HBAdapterInterface
@property (nonatomic, strong) NSString *mCurrentChannel;

@end
