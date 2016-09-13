//
//  EditProfileController.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit
import Fusuma

class EditProfileController: UITableViewController {

    var profile:Dictionary<String, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localization("Thông tin cá nhân")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(selectImage), name: "PROFILE_SELECT_IMAGE", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellEditProfile
        cell.initData(profile)
        return cell
    }
    
    @IBAction func goBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveProfile(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SAVE_PROFILE", object: nil)
    }

    
}

extension EditProfileController: FusumaDelegate {
    func selectImage() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(image: UIImage) {
        NSNotificationCenter.defaultCenter().postNotificationName("PROFILE_SAVE_IMAGE", object: nil, userInfo: ["image":image])
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
}
