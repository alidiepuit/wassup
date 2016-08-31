//
//  Captcha.m
//  wassup
//
//  Created by MAC on 8/17/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

#import "Captcha.h"

@implementation Captcha

-(void)reload_captcha{
    
    @try {
        ar1 = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        i1 = arc4random() % [ar1 count];
        
        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i1);
        
        i2= arc4random() % [ar1 count];
        
        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i2);
        i3 = arc4random() % [ar1 count];
        
        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i3);
        
        i4 = arc4random() % [ar1 count];
        
        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i4);
        
        i5 = arc4random() % [ar1 count];
        
        NSLog(@"RANDOM INDEX:%lu ",(unsigned long)i5);
        
        Captcha_string = [NSString stringWithFormat:@"%@%@%@%@%@",[ar1 objectAtIndex:i1-1],[ar1 objectAtIndex:i2-1],[ar1 objectAtIndex:i3-1],[ar1 objectAtIndex:i4-1],[ar1 objectAtIndex:i5-1]];
        
        NSLog(@" Captcha String : %@",Captcha_string);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

-(BOOL) check:(NSString *)captcha {
    return [captcha isEqualToString:Captcha_string];
}

-(NSString *) getCaptcha {
    return Captcha_string;
}

@end
