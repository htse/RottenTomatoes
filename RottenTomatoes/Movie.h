//
//  Movie.h
//  RottenTomatoes
//
//  Created by Helen Tse on 6/7/14.
//  Copyright (c) 2014 Helen Tse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *posterURL;

@end
