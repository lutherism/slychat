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
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"sly" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available path
    NSString *availableName = [NSString stringWithFormat:@"%d.sly", maxNumber+1];
    NSString *path= [documentsDirectory stringByAppendingPathComponent:availableName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"%@",path);
    return path;
}

-(void)save
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: _myAccount];
    [encodedData writeToFile:[[SlyDatabase filePath] stringByAppendingPathComponent:@"sly.plist"] atomically:YES];
}
+(void)save:(SlyAccount *)sly
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: sly];
    [encodedData writeToFile:[[SlyDatabase filePath] stringByAppendingPathComponent:@"sly.plist"] atomically:YES];
}

+(NSArray *)savedfilePaths
{
    // Get private docs dir
    NSString *documentsDirectory = [SlyDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSMutableArray *savedfiles = [[NSMutableArray alloc]init];
    /*if (files == nil) {
     NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
     return nil;
     }
     */
    // Search for an available name
    
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"sly" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [[documentsDirectory stringByAppendingPathComponent:file] stringByAppendingPathComponent:@"sly.plist"];
            [savedfiles addObject:fileName];
        }
    }
    return savedfiles;
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

-(BOOL)loadSly
{
    for(NSString *f in [SlyDatabase savedfilePaths]){
        NSLog(@"%@",f);
        NSData* decodedData = [NSData dataWithContentsOfFile:f];
        if (decodedData) {
            _myAccount = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
            return true;
        }
    }
    return false;
}


@end
