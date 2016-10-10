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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


