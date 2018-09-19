#import <Cordova/CDVPlugin.h>

@interface CDVMediaScanner : CDVPlugin {}

- (void)insertImage:(UIImage *)image intoAlbumNamed:(NSString *)albumName;

@end
