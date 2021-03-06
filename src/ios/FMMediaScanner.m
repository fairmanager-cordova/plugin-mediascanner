#import "FMMediaScanner.h"

@implementation FMMediaScanner

- (void)scanFileIntoAlbum:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		NSString* fileUri   = [command.arguments objectAtIndex:0];
		NSString* albumName = [command.arguments objectAtIndex:1];

		[self insertImagePath:fileUri intoAlbumNamed:albumName];

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)scanFile:(NSString*)imagePath {
	UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
	return [self insertImage:image intoAlbumNamed: @"Images"];
}

- (void)insertImagePath:(NSString*)imagePath intoAlbumNamed:(NSString*)albumName {
	UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
	return [self insertImage:image intoAlbumNamed: albumName];
}

- (void)insertImage:(UIImage*)image intoAlbumNamed:(NSString*)albumName {
	//Fetch a collection in the photos library that has the title "albumNmame"
	PHAssetCollection* collection = [self fetchAssetCollectionWithAlbumName: albumName];

	if (collection == nil) {
		//If we were unable to find a collection named "albumName" we'll create it before inserting the image
		[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
			[PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle: albumName];
		} completionHandler:^(BOOL success, NSError* _Nullable error) {
			if (error != nil) {
				NSLog(@"Error inserting image into album: %@", error.localizedDescription);
			}

			if (success) {
				//Fetch the newly created collection (which we *assume* exists here)
				PHAssetCollection* newCollection = [self fetchAssetCollectionWithAlbumName:albumName];
				[self insertImage:image intoAssetCollection: newCollection];
			}
		}];
	} else {
		//If we found the existing AssetCollection with the title "albumName", insert into it
		[self insertImage:image intoAssetCollection: collection];
	}
}

- (PHAssetCollection*)fetchAssetCollectionWithAlbumName:(NSString*)albumName {
	PHFetchOptions* fetchOptions = [PHFetchOptions new];
	//Provide the predicate to match the title of the album.
	fetchOptions.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title == '%@'", albumName]];

	//Fetch the album using the fetch option
	PHFetchResult* fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];

	//Assuming the album exists and no album shares it's name, it should be the only result fetched
	return fetchResult.firstObject;
}

- (void)insertImage:(UIImage*)image intoAssetCollection:(PHAssetCollection*)collection {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

		//This will request a PHAsset be created for the UIImage
		PHAssetCreationRequest* creationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];

		//Create a change request to insert the new PHAsset in the collection
		PHAssetCollectionChangeRequest* request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];

		//Add the PHAsset placeholder into the creation request.
		//The placeholder is used because the actual PHAsset hasn't been created yet
		if (request != nil && creationRequest.placeholderForCreatedAsset != nil) {
			[request addAssets: @[creationRequest.placeholderForCreatedAsset]];
		}
	} completionHandler:^(BOOL success, NSError* _Nullable error) {
		if (error != nil) {
			NSLog(@"Error inserting image into asset collection: %@", error.localizedDescription);
		}
	}];
}

@end
