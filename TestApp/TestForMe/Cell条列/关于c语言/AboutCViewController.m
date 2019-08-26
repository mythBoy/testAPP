//
//  AboutCViewController.m
//  TestForMe
//
//  Created by Dance on 2017/4/18.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "AboutCViewController.h"





///*********************** 仿照Class id写一个 *********************/
typedef struct objc_class_ *Class_;

struct objc_class_ {
    Class_ isa  ;

    Class_ super_class  ;                                    // OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;


};


/// Represents an instance of a class.
struct objc_object_ {
    Class_ isa  OBJC_ISA_AVAILABILITY;
};
typedef struct objc_object_ *id_;

@interface AboutCViewController ()

@end

@implementation AboutCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataArray = @[@"DataStructureController"];


}
- (void)kaka
{
//        Class_ cc;
//        cc->isa;
//       (*cc).super_class;
//       Class kk;
//        kk->isa;
    

   
}
//https://blog.csdn.net/liushenge/article/details/78441425


@end
