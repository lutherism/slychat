//
//  AliasDatabase.m
//  slychat
//
//  Created by Alexander Jansen on 4/10/14.
//
//

#import "AliasDatabase.h"

@implementation AliasDatabase

+(NSString*)filePath
{
    // Get private docs dir
    NSString *documentsDirectory = [AliasDatabase getPrivateDocsDir];
    
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
        if ([file.pathExtension compare:@"alias" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available path
    NSString *availableName = [NSString stringWithFormat:@"%d.alias", maxNumber+1];
    NSString *path= [documentsDirectory stringByAppendingPathComponent:availableName];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"%@",path);
    return path;
}

+(void)save:(Alias *) a
{
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject: a];
    [encodedData writeToFile:[[AliasDatabase filePath] stringByAppendingPathComponent:@"alias.plist"] atomically:YES];
}

+(NSArray *)savedfilePaths
{
    // Get private docs dir
    NSString *documentsDirectory = [AliasDatabase getPrivateDocsDir];
    
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
        if ([file.pathExtension compare:@"alias" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [[documentsDirectory stringByAppendingPathComponent:file] stringByAppendingPathComponent:@"alias.plist"];
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

+(NSArray *)loadAliases
{
    NSMutableArray *ali = [[NSMutableArray alloc]init];
    for(NSString *f in [AliasDatabase savedfilePaths]){
        NSLog(@"%@",f);
        NSData* decodedData = [NSData dataWithContentsOfFile:f];
        if (decodedData) {
            Alias* alias = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
            [ali addObject: alias];
        }
    }
    return ali;
}
@end
