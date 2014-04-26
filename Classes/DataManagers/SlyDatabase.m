//
//  SlyDatabase.m
//  slychat
//
//  Created by Alexander Jansen on 4/12/14.
//
//

#import "SlyDatabase.h"

@implementation SlyDatabase

+(NSString*)filePath
{
    // Get private docs dir
    NSString *documentsDirectory = [SlyDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 1;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"sly" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available path
    NSString *availableName = [NSString stringWithFormat:@"%d.sly", maxNumber];
    NSString *path= [documentsDirectory stringByAppendingPathComponent:availableName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"%@",path);
    return path;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: _myAccount];
    NSLog(@"encoding data: %@",[encodedData description]);
    [encodedData writeToFile:[[SlyDatabase filePath] stringByAppendingPathComponent:@"sly.plist"] atomically:YES];
}
+(void)save:(SlyAccount *)sly
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: sly];
    [encodedData writeToFile:[[SlyDatabase filePath]stringByAppendingPathComponent:@"sly.plist"]  atomically:YES];
}

+(NSString *)latestfilePath
{
    // Get private docs dir
    NSString *documentsDirectory = [SlyDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    /*if (files == nil) {
     NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
     return nil;
     }
     */
    // Search for an available name
    
    // Search for an available name
    int maxNumber = 1;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"sly" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available path
    NSString *availableName = [NSString stringWithFormat:@"%d.sly", maxNumber];
    NSString *path= [[documentsDirectory stringByAppendingPathComponent:availableName]stringByAppendingPathComponent:@"sly.plist"];
    
    return path;
    //Get available path
    /*
     NSString *availableName = [NSString stringWithFormat:@"%d.alias", maxNumber+1];
     NSString *path= [documentsDirectory stringByAppendingPathComponent:availableName];
     [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
     NSLog(path);
     return path;*/
}

+ (void)deleteDoc:(NSString *)path {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}

+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+(SlyAccount *)loadSly
{
    NSString *f = [SlyDatabase latestfilePath];
    SlyAccount *sly = [[SlyAccount alloc]init];
        NSData* decodedData = [NSData dataWithContentsOfFile:f];
        if (decodedData) {
            sly = [[NSKeyedUnarchiver unarchiveObjectWithData:decodedData]retain];
            for(Contact *c in [sly getContacts]){
                NSLog(@"contact for alias %@",[[c getMyAlias]getName]);
            }
            return sly;
        }
        else{
            NSLog(@"%@",[decodedData description]);
            return nil;
        }

}
@end
