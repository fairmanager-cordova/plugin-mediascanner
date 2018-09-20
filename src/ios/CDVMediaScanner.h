#import <Cordova/CDVPlugin.h>
#import <Photos/Photos.h>

@interface CDVMediaScanner : CDVPlugin {}

- (void)				insertImage:						(UIImage*)				image
						intoAlbumNamed:						(NSString*)				albumName;
- (PHAssetCollection*)	fetchAssetCollectionWithAlbumName:	(NSString*)				albumName;
- (void)				insertImage:						(UIImage*)				image
						intoAssetCollection:				(PHAssetCollection*)	collection;

@end
