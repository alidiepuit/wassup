//
//  MapsEventHostController.swift
//  wassup
//
//  Created by MAC on 9/28/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class MapsEventHostController: UIViewController {

    var cate = ObjectType.Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("MAPS_SELECT_OBJECT_TYPE", object: nil, userInfo: ["objectType": Int(cate.rawValue)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


