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
    var data:Dictionary<String,AnyObject>!
    var cate:ObjectType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let item = self.tabBar.items![2] 
        item.image = UIImage(named: "ic_flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item.selectedImage = UIImage(named: "ic_flash")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        Utils.sharedInstance.refreshLocation(self, action: nil, loop: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkInFromMainView(_:)), name: "CHECKIN_FROM_MAIN_VIEW", object: nil)
        
    }
    
    func checkInFromMainView(noti: NSNotification) {
        let userInfo = noti.userInfo as! Dictionary<String,AnyObject>
        data = userInfo["data"] as! Dictionary<String,AnyObject>
        cate = ObjectType.valueOf(userInfo["cate"] as! Int)
        self.performSegueWithIdentifier("Checkin", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "Comment" || segue.identifier == "Checkin")
            && data != nil && data!.count > 0 {
            let navi = segue.destinationViewController as! UINavigationController
            let vc = navi.topViewController as! CommentController
            vc.data = data
            vc.cate = cate
            vc.cateView = segue.identifier == "Comment" ? ObjectType.Comment : ObjectType.Checkin
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("CLOSE_SEARCH_KEYWORD_WHEN_CHANGE_TAG", object: nil)
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveComment(sender: UIStoryboardSegue) {
        if let vc = sender.sourceViewController as? CommentController, data = vc.saveData {
            let arrImage = data["arrImage"] as! [UIImage]
            let description = CONVERT_STRING(data["description"])
            let cate = ObjectType.valueOf(data["cate"] as! Int)
            let md = User()
            md.checkin(cate, id: CONVERT_STRING(data["id"]), description: description, images: arrImage, callback: nil)
        }
    }
    
    
}
