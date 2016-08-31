//
//  MainController.swift
//  wassup
//
//  Created by MAC on 8/18/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit
import GoogleMaps

class MainController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let item = self.tabBar.items![2] 
        item.image = UIImage(named: "ic_flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item.selectedImage = UIImage(named: "ic_flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        Utils.sharedInstance.refreshLocation(self, action: nil, loop: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}