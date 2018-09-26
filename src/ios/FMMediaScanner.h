#import <Cordova/CDVPlugin.h>
#import <Photos/Photos.h>

@interface FMMediaScanner : CDVPlugin {}

- (void)scanFileIntoAlbum:(CDVInvokedUrlCommand*)command;

- (void)				insertImagePath:					(NSString*)				imagePath
						intoAlbumNamed:						(NSString*)				albumName;

- (void)				insertImage:						(UIImage*)				image
						intoAlbumNamed:						(NSString*)				albumName;

- (void)				insertImage:						(UIImage*)				image
						intoAssetCollection:				(PHAssetCollection*)	collection;

- (PHAssetCollection*)	fetchAssetCollectionWithAlbumName:	(NSString*)				albumName;

@end
