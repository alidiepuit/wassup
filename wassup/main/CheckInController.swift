//
//  FeedsController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class CheckInController: UIViewController {
    var tabPage:TabPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        GLOBAL_KEYWORD = ""
        Utils.sharedInstance.refreshLocation(self, action: nil, loop: false)
        
        tabPage = TabPageViewController.create()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("CheckInEventController") as! CheckInEventController
        vc1.typeSearch = ObjectType.Event
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("CheckInEventController") as! CheckInEventController
        vc2.typeSearch = ObjectType.Host
        tabPage!.tabItems = [(vc2, Localization("Địa điểm")), (vc1, Localization("Sự kiện"))]
        
        var option = TabPageOption()
        option.currentColor = UIColor.fromRgbHex(0x31ACF9)
        option.tabEqualizeWidth = true
        option.numberOfItem = 2
        tabPage!.option = option
        
        self.addChildViewController(tabPage!)
        tabPage!.view.frame = self.view.frame
        self.view.addSubview(tabPage!.view)
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showDetailCheckIn), name: "SHOW_DETAIL_CHECK_IN", object: nil)
    }
    
    func showDetailCheckIn() {
//        self.performSegueWithIdentifier("DetailCheckIn", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
